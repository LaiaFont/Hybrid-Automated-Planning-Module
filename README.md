# Hybrid Automated Planning Module (HAPM)
Welcome to the Hybrid Automated PLanning Module repository! In it you will find the code used for my master's thesis (An Adaptive and Gamified Educational Experience using Chatbots) experiments.

In here you will find both test case codes: Project Management (PM) and Study Exam (SE). You will find the domains and the different proposed problems.

Additionally, you will find the Telegram chatbot prototype that implements the HAPM.

## Run the HAPM
In order to execute the domain and problems there exist two options: copy pasting the code into the https://editor.planning.domains/# webpage and selecting the solver to "ENHSP" or using the VSCode extension for PDDL. I recommend the second.

### Run on Planning.domains
To run in the planning.domains editor, follow this steps:
- Open your preferred browser
- Enter this url https://editor.planning.domains/#
- You will see a blank file, open another one by clicking on the top menu on File > New
- On the first file paste the desired domain from the repository, copy the whole text
- On the second file, copy the desired problem definition from the repository and paste it on the second file
- Once both files on the webpage have the domain and the problem, search for the Solver button in the top menu and click on it
- A pop-up will appear, make sure the domain has assigned the first file and the problem the second
- Select ENHSP from the dropdown as the Solver
- Click on Plan and wait till you obtain the solution under the documents on the left bar

### Run on VSCode
To run on VSCode, you first have to install this extension https://marketplace.visualstudio.com/items?itemName=jan-dolejsi.pddl

Then follow these steps:
- After following the installation instructions of the extension, open the repository folder on VSCode
- Open the desired problem to obtain the plan for
- Press Alt + P to select the solver
- Select ENHSP from the list and press ENTER
- Wait for the plan to be returned, a new screen will open with the found plan

## Run the chatbot prototype
To run the chatbot prototype you need to obtain a Telegram bot API key, together with an OpenAI API key. Then follow these steps:

- Create a new virtual environment 
```python -m venv .venv```
- Activate the virtual environment
- Go to the chatbot-prototype folder through the terminal
```cd chatbot-prototype```
- Install the required packages
```pip install -r requirements.txt```
- Once installed, you just need to run the bot.py script
```python bot.py```

To view the chatbot, go into Telegram and search for @mIA_ub_planning_bot and start talking to it through /plan <plan_description>.