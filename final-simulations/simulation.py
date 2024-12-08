import pygame
import numpy as np
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
        self.observation_space = Box(low=0, high=10, shape=(len(self.tasks),), dtype=int)

        # Initialize the state
        self.state = np.array([task['remaining_time'] for task in self.tasks.values()])
        self.agent_selection = None

        # Pygame initialization
        pygame.init()
        self.screen = pygame.display.set_mode((800, 600))
        pygame.display.set_caption("Project Management Simulation")
        self.clock = pygame.time.Clock()

        # Define positions for tasks and students
        self.task_positions = {
            'coding1': (200, 300),
            'coding2': (300, 300),
            'design1': (200, 400),
            'design2': (300, 400),
            'research1': (200, 200),
            'research2': (300, 200),
        }
        self.student_positions = {
            'student1': (50, 250),
            'student2': (50, 350),
            'student3': (50, 150),
        }

    def reset(self):
        """Reset the environment state."""
        self.state = np.array([task['remaining_time'] for task in self.tasks.values()])
        self.total_time = 60
        self.available_time = {'student1': 5, 'student2': 8, 'student3': 10}
        self.agent_selection = self.agents[0]
        return self.state

    def step(self, action):
        """Take a step in the environment."""
        agent = self.agent_selection
        
        # Assign task action
        if action == 0:
            for task_name, task_info in self.tasks.items():
                if task_info['assigned'] is None and task_info['role'] in self.roles[agent] and self.available_time[agent] > 0:
                    task_info['assigned'] = agent
                    self.available_time[agent] -= 1
                    break
        # Work on task action
        elif action == 1:
            for task_name, task_info in self.tasks.items():
                if task_info['assigned'] == agent and task_info['remaining_time'] > 0:
                    task_info['remaining_time'] -= 1
                    self.available_time[agent] -= 1
                    self.total_time -= 1
                    break
        # Complete task action
        elif action == 2:
            for task_name, task_info in self.tasks.items():
                if task_info['assigned'] == agent and task_info['remaining_time'] == 0:
                    task_info['assigned'] = None
                    break
        
        done = all(task['remaining_time'] == 0 for task in self.tasks.values())
        reward = -self.total_time

        next_agent_index = (self.agents.index(agent) + 1) % len(self.agents)
        self.agent_selection = self.agents[next_agent_index]

        return self.state, reward, done, {}

    def render(self):
        """Render the environment using Pygame."""
        self.screen.fill((255, 255, 255))

        # Draw tasks
        for task_name, task_info in self.tasks.items():
            x, y = self.task_positions[task_name]
            color = (0, 0, 255) if task_info['remaining_time'] > 0 else (0, 255, 0)
            pygame.draw.circle(self.screen, color, (x, y), 20)
            text = pygame.font.SysFont(None, 24).render(f"{task_name}: {task_info['remaining_time']}", True, (0, 0, 0))
            self.screen.blit(text, (x - 40, y + 25))

        # Draw students
        for student_name, position in self.student_positions.items():
            x, y = position
            pygame.draw.rect(self.screen, (255, 0, 0), (x, y, 40, 40))
            text = pygame.font.SysFont(None, 24).render(student_name, True, (0, 0, 0))
            self.screen.blit(text, (x, y - 20))

        pygame.display.flip()
        self.clock.tick(30)

    def close(self):
        """Close the Pygame display."""
        pygame.quit()


env = ProjectManagementEnv()
env.reset()

done = False

# Main loop
while not done:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:  # Handle the quit event
            done = True

    # Agent actions and environment updates
    for agent in env.agents:
        action = env.action_space.sample()  # Random action for testing
        state, reward, done, _ = env.step(action)
        env.render()  # Render the environment
        if done:
            break

env.close()

