import pygame
import time

# Constants for visualization
SCREEN_WIDTH, SCREEN_HEIGHT = 600, 400
FPS = 60
AGENT_SIZE = 20
TASK_SIZE = 15
MOVE_SPEED = 2

# Colors
WHITE = (255, 255, 255)
BLUE = (0, 0, 255)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
BLACK = (0, 0, 0)

# Define positions for tasks and agents
TASK_POSITIONS = {
    'coding1': (100, 100),
    'coding2': (400, 100),
    'design1': (100, 300),
    'design2': (400, 300),
    'research1': (250, 50),
    'research2': (250, 350)
}

AGENT_START_POSITIONS = {
    'student1': [50, 200],
    'student2': [50, 250],
    'student3': [50, 150]
}

# Define the plan
PLAN = [
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

class Task:
    def __init__(self, name, position):
        self.name = name
        self.position = position
        self.completed = False
        self.in_progress = False

    def draw(self, screen, font):
        if self.completed:
            return
        color = GREEN if self.in_progress else BLUE
        pygame.draw.circle(screen, color, self.position, TASK_SIZE)
        # Draw the task name
        label = font.render(self.name, True, BLACK)
        screen.blit(label, (self.position[0] - TASK_SIZE, self.position[1] - TASK_SIZE * 2))

class Agent:
    def __init__(self, name, start_position):
        self.name = name
        self.position = start_position[:]
        self.target = None

    def move_toward(self, target_position):
        """Move agent toward the target position."""
        if self.position[0] < target_position[0]:
            self.position[0] += MOVE_SPEED
        elif self.position[0] > target_position[0]:
            self.position[0] -= MOVE_SPEED
        if self.position[1] < target_position[1]:
            self.position[1] += MOVE_SPEED
        elif self.position[1] > target_position[1]:
            self.position[1] -= MOVE_SPEED

    def is_at_target(self, target_position):
        """Check if the agent has reached the target position."""
        return abs(self.position[0] - target_position[0]) < MOVE_SPEED and \
               abs(self.position[1] - target_position[1]) < MOVE_SPEED

    def draw(self, screen, font):
        pygame.draw.rect(screen, RED, (*self.position, AGENT_SIZE, AGENT_SIZE))
        # Draw the agent name
        label = font.render(self.name, True, BLACK)
        screen.blit(label, (self.position[0], self.position[1] - AGENT_SIZE))

def simulate(plan, screen, clock, tasks, agents, font):
    """Simulate the given plan."""
    for action in plan:
        print(f"Executing action: {action}")
        if "assign-task" in action:
            _, agent_name, task_name, _ = action.split()
            agents[agent_name].target = tasks[task_name].position
            tasks[task_name].in_progress = True
        elif "complete-task" in action:
            _, agent_name, task_name = action.split()
            tasks[task_name].completed = True
            tasks[task_name].in_progress = False
            agents[agent_name].target = None
        elif "waiting" in action:
            # Waiting for a specified time
            time.sleep(1)

        # Animate the movement
        while any(agent.target for agent in agents.values()):
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.quit()
                    return

            # Update screen
            screen.fill(WHITE)
            for task in tasks.values():
                task.draw(screen, font)
            for agent in agents.values():
                if agent.target and not tasks[task_name].completed:
                    agent.move_toward(agent.target)
                    if agent.is_at_target(agent.target):
                        agent.target = None
                agent.draw(screen, font)

            pygame.display.flip()
            clock.tick(FPS)

def main():
    pygame.init()
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    clock = pygame.time.Clock()
    font = pygame.font.SysFont(None, 24)

    # Initialize tasks and agents
    tasks = {name: Task(name, position) for name, position in TASK_POSITIONS.items()}
    agents = {name: Agent(name, position) for name, position in AGENT_START_POSITIONS.items()}

    # Run the simulation
    simulate(PLAN, screen, clock, tasks, agents, font)

    pygame.quit()

if __name__ == "__main__":
    main()
