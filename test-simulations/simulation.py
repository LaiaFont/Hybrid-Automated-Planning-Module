import numpy as np
import matplotlib.pyplot as plt
from pettingzoo import AECEnv
from gymnasium.spaces import Discrete, Box

class ProjectManagementEnv(AECEnv):
    def __init__(self):
        super().__init__()

        # Define the agents (students)
        self.agents = ['student1', 'student2', 'student3']
        
        # Define task information (e.g., remaining time, priority)
        self.tasks = {
            'coding1': {'role': 'developer', 'remaining_time': 2, 'priority': 1, 'assigned': None},
            'coding2': {'role': 'developer', 'remaining_time': 2, 'priority': 2, 'assigned': None},
            'design1': {'role': 'designer', 'remaining_time': 1, 'priority': 3, 'assigned': None},
            'design2': {'role': 'designer', 'remaining_time': 1, 'priority': 4, 'assigned': None},
            'research1': {'role': 'researcher', 'remaining_time': 7, 'priority': 1, 'assigned': None},
            'research2': {'role': 'researcher', 'remaining_time': 7, 'priority': 3, 'assigned': None},
        }

        # Define roles for students (actions)
        self.roles = {'student1': ['developer'], 'student2': ['designer', 'researcher'], 'student3': ['developer', 'researcher']}
        
        # Time available for students to work
        self.available_time = {'student1': 5, 'student2': 8, 'student3': 10}

        # Total time to minimize
        self.total_time = 60

        # Initialize the state space and action space
        self.action_space = Discrete(3)

        # Define observations (e.g., remaining time, roles, tasks)
        self.observation_space = Box(low=0, high=10, shape=(len(self.tasks),), dtype=int)

        # Initialize the state (remaining times of tasks)
        self.state = np.array([task['remaining_time'] for task in self.tasks.values()])
        
        # Initialize agent selection (to be handled properly in reset)
        self.agent_selection = None
        
        # Initialize matplotlib plot
        self.fig, self.ax = plt.subplots(figsize=(10, 6))
        self.task_positions = {
            'coding1': (1, 4),
            'coding2': (3, 4),
            'design1': (1, 2),
            'design2': (3, 2),
            'research1': (1, 6),
            'research2': (3, 6),
        }
        self.student_positions = {
            'student1': (0, 3),
            'student2': (0, 2),
            'student3': (0, 5),
        }

    def reset(self):
        """Reset the environment state."""
        self.state = np.array([task['remaining_time'] for task in self.tasks.values()])
        self.total_time = 60  # Reset total time
        self.available_time = {'student1': 5, 'student2': 8, 'student3': 10}
        
        # Select the first agent to start
        self.agent_selection = self.agents[0]
        
        # Reset the plot
        self.ax.clear()
        self.update_visualization()
        
        return self.state
    
    def step(self, action):
        """Take a step in the environment."""
        agent = self.agent_selection
        
        # Assign task action (action 0)
        if action == 0:
            # Iterate over tasks and check if they can be assigned to the student
            for task_name, task_info in self.tasks.items():
                if task_info['assigned'] is None:  # Task is unassigned
                    # Check if the student has the correct role for the task
                    if self.roles[agent] and task_info['role'] in self.roles[agent]:
                        # Ensure the student has available time and task has remaining time
                        if self.available_time[agent] > 0 and task_info['remaining_time'] > 0:
                            # Assign task
                            self.tasks[task_name]['assigned'] = agent
                            self.available_time[agent] -= 1  # Student spends 1 time unit assigning the task
                            print(f"{agent} has been assigned task {task_name}")
                            break  # Exit after assigning a task to this agent
        # Work on task action (action 1)
        elif action == 1:
            # Check if the student has a task assigned
            assigned_task = None
            for task_name, task_info in self.tasks.items():
                if task_info['assigned'] == agent and task_info['remaining_time'] > 0:
                    assigned_task = task_name
                    break

            if assigned_task:
                # Decrease task remaining time and student available time
                self.tasks[assigned_task]['remaining_time'] -= 1
                self.available_time[agent] -= 1
                self.total_time -= 1  # Total time is also decreased
                print(f"{agent} worked on task {assigned_task}. Remaining time for task: {self.tasks[assigned_task]['remaining_time']}")
        # Complete task action (action 2)
        elif action == 2:
            # Check if the student has a task assigned and if it is complete
            assigned_task = None
            for task_name, task_info in self.tasks.items():
                if task_info['assigned'] == agent and task_info['remaining_time'] == 0:
                    assigned_task = task_name
                    break

            if assigned_task:
                # Mark task as completed and unassign the student
                self.tasks[assigned_task]['assigned'] = None
                print(f"{agent} completed task {assigned_task}")
        
        # Update the done flag (check if all tasks are completed)
        done = all(task_info['remaining_time'] == 0 for task_info in self.tasks.values())
        
        # Reward function (could be based on time left and completion)
        reward = -self.total_time  # Example: more negative the total time, worse the outcome
        
        # Determine the next agent to select
        next_agent_index = (self.agents.index(agent) + 1) % len(self.agents)
        self.agent_selection = self.agents[next_agent_index]
        
        # Update the plot
        self.update_visualization()
        
        return self.state, reward, done, {}
    
    def render(self):
        """Render the current state."""
        self.ax.clear()
        self.update_visualization()
        plt.pause(0.1)
    
    def update_visualization(self):
        """Update the visualization of tasks and students."""
        # Plot tasks as blue circles
        for task_name, task_info in self.tasks.items():
            x, y = self.task_positions[task_name]
            if task_info['remaining_time'] > 0:  # Only plot uncompleted tasks
                self.ax.scatter(x, y, s=100, c='blue', label=task_name)
        
        # Plot students as red boxes
        for student_name, position in self.student_positions.items():
            self.ax.scatter(position[0], position[1], s=200, c='red', marker='s', label=student_name)
        
        # Set labels and title
        self.ax.set_title("Project Management Simulation")
        self.ax.set_xlabel("X Position")
        self.ax.set_ylabel("Y Position")
        
        # Remove duplicate labels
        handles, labels = self.ax.get_legend_handles_labels()
        unique_labels = dict(zip(labels, handles))
        self.ax.legend(unique_labels.values(), unique_labels.keys())
    
    def close(self):
        """Close the environment."""
        plt.close(self.fig)

# Create the environment
env = ProjectManagementEnv()

# Run an example simulation loop
env.reset()
done = False

while not done:
    for agent in env.agents:
        action = env.action_space.sample()  # Random action for testing
        state, reward, done, info = env.step(action)
        env.render()
        if done:
            break

env.close()
