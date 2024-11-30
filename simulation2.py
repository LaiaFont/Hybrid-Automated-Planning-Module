import numpy as np
import matplotlib.pyplot as plt
from pettingzoo import AECEnv
from gymnasium.spaces import Discrete, Box

class ProjectManagementEnv(AECEnv):
    def __init__(self, plan):
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
        self.observation_space = Box(low=0, high=10, shape=(len(self.tasks),), dtype=np.int)

        # Initialize the state (remaining times of tasks)
        self.state = np.array([task['remaining_time'] for task in self.tasks.values()])
        
        # Store the plan
        self.plan = plan
        self.plan_idx = 0  # Index to track the current step in the plan
        
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
    
    def step(self):
        """Execute the current step of the plan."""
        if self.plan_idx >= len(self.plan):
            return self.state, 0, True, {}  # Done if no more actions
        
        # Get current action from the plan
        action = self.plan[self.plan_idx]
        self.plan_idx += 1
        
        # Execute the action
        if action.startswith("assign-task"):
            # Extract the student and task details
            _, student, task, role = action.split()
            if self.tasks[task]['assigned'] is None:
                if role in self.roles[student] and self.available_time[student] > 0 and self.tasks[task]['remaining_time'] > 0:
                    self.tasks[task]['assigned'] = student
                    self.available_time[student] -= 1
                    print(f"{student} has been assigned task {task}.")
        
        elif action.startswith("complete-task"):
            # Extract the student and task details
            _, student, task = action.split()
            if self.tasks[task]['assigned'] == student and self.tasks[task]['remaining_time'] == 0:
                self.tasks[task]['assigned'] = None
                print(f"{student} completed task {task}.")
        
        elif "waiting" in action:
            print(f"Waiting... ({action})")
        
        # Update the done flag (check if all tasks are completed)
        done = all(task_info['remaining_time'] == 0 for task_info in self.tasks.values())
        
        # Reward function (could be based on time left and completion)
        reward = -self.total_time  # Example: more negative the total time, worse the outcome
        
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

# Example plan based on the provided sequence
plan = [
    "assign-task student3 coding1 developer", 
    "assign-task student1 coding1 developer", 
    "assign-task student2 research1 researcher", 
    "waiting", 
    "complete-task student3 coding1", 
    "complete-task student1 coding1", 
    "assign-task student3 research1 researcher", 
    "waiting", 
    "complete-task student2 research1", 
    "assign-task student1 coding2 developer", 
    "complete-task student3 research1", 
    "assign-task student3 coding2 developer", 
    "waiting", 
    "complete-task student3 coding2", 
    "assign-task student3 research2 researcher", 
    "complete-task student1 coding2", 
    "assign-task student2 design1 designer", 
    "waiting", 
    "complete-task student2 design1", 
    "waiting", 
    "assign-task student2 research2 researcher", 
    "waiting", 
    "complete-task student2 research2", 
    "assign-task student2 design2 designer", 
    "waiting", 
    "complete-task student2 design2"
]

# Create the environment
env = ProjectManagementEnv(plan)

# Run an example simulation loop
env.reset()
done = False

while not done:
    state, reward, done, info = env.step()
    env.render()
    
env.close()
