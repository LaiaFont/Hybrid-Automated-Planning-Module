import os
import telebot
from telebot import types
import time
import requests
from dotenv import load_dotenv

load_dotenv()

BOT_TOKEN = os.getenv('BOT_TOKEN')

def solveProblem(domain, problem):
    print("solveProblem function called")
    url = "https://solver.planning.domains:5001/package/enhsp/solve"

    with open(domain, "r") as domain_file:
        domain_content = domain_file.read()

    with open(problem, "r") as problem_file:
        problem_content = problem_file.read()

    payload = {
        "domain": domain_content,
        "problem": problem_content
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
        plan, raw_plan = solveProblem("../PM-planning/domain.pddl", "../PM-planning/problem_1.pddl")
        button_foo = types.InlineKeyboardButton('Yes', callback_data='yes')
        button_bar = types.InlineKeyboardButton('No', callback_data='no')

        keyboard = types.InlineKeyboardMarkup()
        keyboard.add(button_foo)
        keyboard.add(button_bar)

        if raw_plan:
            bot.reply_to(message, f"Found plan with length of {plan[-1][0]} days")
            bot.send_message(message.chat.id, "Do you want to see the plan?", reply_markup=keyboard)
        else:
            bot.reply_to(message, "No solution could be found. Please check your inputs.")
    except Exception as e:
        print(f"Error handling /plan command: {e}")
        bot.reply_to(message, "An error occurred while processing your request.")

@bot.callback_query_handler(func=lambda call: call.data in ['yes', 'no'])
def callback_handler(call):
    cid = call.message.chat.id
    mid = call.message.message_id
    answer = call.data
    print(call)
    if answer == 'yes':
        print("Hello")

@bot.message_handler(func=lambda msg: True)
def echo_all(message):
    bot.reply_to(message, message.text)

bot.infinity_polling()
