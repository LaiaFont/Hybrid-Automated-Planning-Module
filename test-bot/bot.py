import os
import telebot
from telebot import types
import time
import requests
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

BOT_TOKEN = os.getenv('BOT_TOKEN')
OPEN_AI = os.getenv('OPEN_AI')

user_plans = {}

def getDomain(type):
    domain = '../PM-planning/domain.pddl' if type == 1 else '../exam-planning/domain_groups.pddl'
    problem = '../PM-planning/problem_1.pddl' if type == 1 else '../exam-planning/problem_1_groups.pddl'

    with open(domain, "r") as domain_file:
        domain_content = domain_file.read()

    with open(problem, "r") as problem_file:
        problem_content = problem_file.read()
    return domain_content, problem_content

def solveProblem(domain, problem):
    print("solveProblem function called")
    url = "https://solver.planning.domains:5001/package/enhsp/solve"

    with open(domain, "r") as domain_file:
        domain_content = domain_file.read()

    # with open(problem, "r") as problem_file:
    #     problem_content = problem_file.read()

    payload = {
        "domain": domain_content,
        "problem": problem
    }

    response = requests.post(url, json=payload)
    print(f"Response from solver: {response.status_code}")

    if response.status_code == 200:
        result = response.json()
        result_url = 'https://solver.planning.domains:5001' + result.get('result')

        # Poll the result until it's ready
        while True:
            status_response = requests.post(result_url, json={"external": True})
            if status_response.status_code == 200:
                status = status_response.json()
                if status.get("status") == "PENDING":
                    print("Solution is still pending. Waiting...")
                    time.sleep(2)
                else:
                    print("Solution is ready:")
                    full_output = status['result']['output']['plan']
                    
                    # Extract the plan part
                    plan_lines = []
                    for line in full_output.split("\n"):
                        line = line.strip()
                        # Skip empty lines
                        if not line:
                            continue
                        # Check if the line starts with a valid plan step (e.g., "0:" or "4.0:")
                        if line[0].isdigit() and ":" in line:
                            plan_lines.append(line)
                        # Stop recording if metadata is encountered
                        elif plan_lines:
                            break
                    
                    formatted_plan = "\n".join(plan_lines)

                    return plan_lines, formatted_plan
            else:
                print(f"Failed to check status: {status_response.status_code}")
                print(status_response.text)
                break
    else:
        print(f"Failed to get solution: {response.status_code}")
        print(response.text)
        return "Error occurred while solving the problem."
    
bot = telebot.TeleBot(BOT_TOKEN)

@bot.message_handler(commands=['start', 'hello'])
def send_welcome(message):
    bot.reply_to(message, "Howdy, how are you doing?")

@bot.message_handler(commands=['plan'])
def return_problem(message):
    try:
        print("Handling /plan command")
        client = OpenAI(api_key=OPEN_AI)
        domain, problem = getDomain(1)
        prompt = f"""Imagine you are a project manager, with the aim to help students become more productive with their school/uni projects. To do so, you use PDDL+ with ENHSP to provide them with customized plans. With the provided domain 
        "{domain}" return a problem file, taking this file structure into account "{problem}", that will fit with the description provided by the group of students:
        {message}
        Please provide to solely the problem file (no extra tasks apart from the problem code) to execute the planner making sure the problem is solvable based on the domain"""

        try:
            response = client.chat.completions.create(
                model='gpt-4o-mini',
                messages=[
                    {"role": "system", "content": prompt}
                ],
                temperature=0.7,
                timeout=20
            )

            code = response.choices[0].message.content

            cleaned_code = None
            start_idx = code.find('(')
            end_idx = code.rfind(')')

            if start_idx != -1 and end_idx != -1:
                cleaned_code = code[start_idx:end_idx + 1].strip()
            else:
                print("Error: Unexpected response format. Code extraction failed.")
                bot.reply_to(message, "Failed to process the OpenAI response. Please try again.")
        
            plan, raw_plan = solveProblem("../PM-planning/domain.pddl", cleaned_code)
            
            user_plans[message.chat.id] = raw_plan

            button_foo = types.InlineKeyboardButton('Yes', callback_data='yes')
            button_bar = types.InlineKeyboardButton('No', callback_data='no')

            keyboard = types.InlineKeyboardMarkup()
            keyboard.add(button_foo)
            keyboard.add(button_bar)

            if raw_plan:
                bot.reply_to(message, f"Found plan with length of {plan[-1][0]} days")
                bot.send_message(message.chat.id, "Would you like to see the plan?", reply_markup=keyboard)
            else:
                bot.reply_to(message, "No solution could be found. Please check your inputs.")
                
        except Exception as e:
            print(f"Error handling /plan command: {e}")
            bot.reply_to(message, "Cannot connect to OPENAI's API.")

    except Exception as e:
        print(f"Error handling /plan command: {e}")
        bot.reply_to(message, "An error occurred while processing your request.")

@bot.callback_query_handler(func=lambda call: call.data in ['yes', 'no'])
def callback_handler(call):
    cid = call.message.chat.id
    mid = call.message.message_id
    answer = call.data

    if answer == 'yes':
        plan = user_plans.get(cid)
        if plan:
            bot.send_message(cid, f"Here is your plan:\n\n{plan}")
        else:
            bot.send_message(cid, "Sorry, no plan was found for your request.")
    elif answer == 'no':
        bot.send_message(cid, "Alright! Let me know if you need help with anything else.")

@bot.message_handler(func=lambda msg: True)
def echo_all(message):
    bot.reply_to(message, message.text)

bot.infinity_polling()
