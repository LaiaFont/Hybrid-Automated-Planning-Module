# Hybrid Automated Planning Module (HAPM)

Welcome to the Hybrid Automated Planning Module (HAPM) repository! This repository contains the code and resources used for experiments conducted as part of my master's thesis: **"An Adaptive and Gamified Educational Experience using Chatbots."** as an enhancement module for the mIA-UB chatbot ([look at previous work](https://diposit.ub.edu/dspace/handle/2445/201894)).

The repository includes:
- Test case codes for:
  - **Project Management (PM)**
  - **Study Exam (SE)**
- Domains and proposed problem definitions.
- A **Telegram chatbot prototype** implementing the HAPM.
- A **RAG implementation test** notebook.

## Repository Structure
The repository is organized as follows:
```
Hybrid Automated Planning Module/
├── PM-planning/
    ├── domain.pddl
    ├── problem_1.pddl
    ├── problem_2.pddl
    ├── problem_3.pddl
├── SE-planning/
    ├── domain.pddl
    ├── problem_1.pddl
    ├── problem_2.pddl
    ├── problem_3.pddl
├── RAG-testing/
    ├── PresentacioCurs24-25.pdf
    ├── RAG.ipynb
└── chatbot-prototype/
    ├── .env.example
    ├── bot.py
    ├── requirements.txt
```

---

## Running the HAPM
You can execute the domains and problems using one of two options:
1. **Online PDDL Editor** (via Planning.domains)
2. **VSCode with PDDL Extension** (recommended)

### Option 1: Run on Planning.domains
To execute HAPM using the Planning.domains editor:
1. Open your preferred browser and go to [Planning.domains editor](https://editor.planning.domains/#).
2. In the editor:
   - Open a new file via `File > New` from the top menu.
   - Copy and paste the desired domain from this repository into the first file.
   - Copy and paste the desired problem definition into the second file.
3. Click the `Solver` button in the top menu. A pop-up window will appear:
   - Assign the domain file to the **Domain** section.
   - Assign the problem file to the **Problem** section.
4. From the Solver dropdown, select `ENHSP`.
5. Click `Plan` and wait for the solution to appear in the left panel under the documents section.

### Option 2: Run on VSCode
To execute HAPM using VSCode:
1. Install the [PDDL Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=jan-dolejsi.pddl).
2. Open the repository folder in VSCode.
3. Open the desired problem file to generate a plan.
4. Press `Alt + P` to open the solver selection menu.
5. Select `ENHSP` from the list and press `Enter`.
6. Wait for the plan to generate. The plan will appear in a new tab within VSCode.

---

## Running the Chatbot Prototype
To run the chatbot prototype, you will need:
- A **Telegram Bot API Key**.
- An **OpenAI API Key**.

### Steps to Run the Chatbot:
1. Create a new virtual environment:
   ```bash
   python -m venv .venv
   ```
2. Activate the virtual environment:
   - **Windows**: `.\.venv\Scripts\activate`
   - **Mac/Linux**: `source .venv/bin/activate`
3. Navigate to the `chatbot-prototype` folder:
   ```bash
   cd chatbot-prototype
   ```
4. Install the required packages:
   ```bash
   pip install -r requirements.txt
   ```
5. Run the bot script:
   ```bash
   python bot.py
   ```

### Accessing the Chatbot
1. Open Telegram and search for `@mIA_ub_planning_bot`.
2. Interact with the bot using the `/plan <plan_description>` command.

---
## Executing the RAG implementation test
Run all the cells of the RAG notebook, you will be asked and OpenAI API key. Make sure the file you want to use is in the same folder as the notebook and that the path is correctly specified in variable **pdf_file_path**.

---

## Contribution
Contributions, suggestions, or bug reports are welcome! Please open an issue or submit a pull request for any improvements.

---

Feel free to reach out if you have any questions or need assistance!