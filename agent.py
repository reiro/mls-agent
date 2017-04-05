from fuzzywuzzy import fuzz
from fuzzywuzzy import process
from itertools import groupby
from word2number import w2n
import nltk
import code
import usaddress
import re

def isfloat(x):
    try:
        a = float(x)
    except ValueError:
        return False
    else:
        return True

# Messages analizers =======================================================================

def group_by_category(statements, groups):
    for s in statements:
        groups[s[0]].append(s)

    return groups

def analyze_message(msg, sets, scorer):
    result = []
    for key, set in sets.iteritems():
        best_score = process.extractOne(msg, set, scorer=scorer)[1]
        result.append(tuple([key, best_score]))

    return result

def choose_top_category(scores, msg):
    top_set = sorted(scores, key=lambda (k): (k[1]), reverse=True)[0]
    top_set += (msg,)

    return top_set

def analyze_messages(word_lists, sets, scorer):
    result = []
    for word_list in word_lists:
        msg = " ".join(map(str, word_list))
        scores = analyze_message(msg, sets, scorer)
        analyzed_messages = choose_top_category(scores, msg)
        result.append(analyzed_messages)

    return result

# message parsers =======================================================================

def default_response():
    return 'Try some other message, please!'

def greetings_response(statement):
    return ['Good day!', True]

def actions_response(statement):
    action_statements = analyze_message(statement, actions_parse, fuzz.token_set_ratio)
    action_statements.sort(key=lambda tup: tup[1], reverse=True) # top tuple by scores [('buy', 100), ('rent', 33), ('sell', 0)]

    return [action_statements[0][0], True]

def beds_response(statement):
    return parse_number(statement)

def baths_response(statement):
    return parse_number(statement)

def price_response(statement):
    print statement
    print "==============="
    #parse max min between and integer
    result = re.sub('[^0-9]','', statement)
    return parse_number(result)

def address_response(statement):
    #parse state, streed, home number
    return parse_address(statement)

def hasNumbers(inputString):
    return any(char.isdigit() for char in inputString)

def parse_number(statement):
    result = None
    has_number = False
    number_index = 0
    tokens = nltk.word_tokenize(statement)
    tagged = nltk.pos_tag(tokens)

    for i, tag in enumerate(tagged):
        if tag[1] == 'CD':
            has_number = True
            number_index = i
            result = tag[0].replace(",", ".") # 3.5 of three
            if not isfloat(result):
                result = w2n.word_to_num(result)

    return [result, has_number, number_index, len(tokens)]

def parse_address(statement):
    address = usaddress.tag(statement)
    address = dict(address)


# =======================================================================


# text wrappers =======================================================================

def greetings_wrap(message):
    return 'Good day!'

def actions_wrap(message):
    return 'I will help you ' + message + ' a home.'

def beds_wrap(message):
    return 'You want home with '+ message + ' bed(s).'

def baths_wrap(message):
    return 'You want home with '+ message + ' bath(s).'

def price_wrap(message):
    #parse max min between and integer
    return 'Your budget is ' + message + '.'

def address_wrap(message):
    #parse state, streed, home number
    return 'I now your future address.'

# =======================================================================

# Questions generations ========================================================

def actions_question():
    return 'Do you want buy, sell or rent a home?'

def beds_question():
    return 'How many beds do you want?'

def baths_question():
    return 'How many baths do you want?'

def price_question():
    return 'How much money do you have for home?'

def address_question():
    return 'Please tell me address do you want?'

# ============================================================================



# bot API functions =======================================================================

def questions_category(category):
    switcher = {
        'actions': 'actions_question',
        'beds': 'beds_question',
        'baths': 'baths_question',
        'price': 'price_question',
        'address': 'address_question'
    }

    func = switcher.get(category)
    return globals()[func]()


def perform_category(category, statement):
    switcher = {
        'greetings': 'greetings_response',
        'actions': 'actions_response',
        'beds': 'beds_response',
        'baths': 'baths_response',
        'price': 'price_response',
        'address': 'address_response'
    }

    func = switcher.get(category)
    return globals()[func](statement)

def wrap_category(category, sentence):
    switcher = {
        'greetings': 'greetings_wrap',
        'actions': 'actions_wrap',
        'beds': 'beds_wrap',
        'baths': 'baths_wrap',
        'price': 'price_wrap',
        'address': 'address_wrap'
    }

    func = switcher.get(category)
    return globals()[func](sentence)

def answer_category(category, statements):
    results = []
    for statement in statements:
        if statement[1] > 80:
            #msg = statement[2]
            #scores = analyze_message(msg, sets, fuzz.ratio)
            #analyzed_message = choose_top_category(scores, msg)

            response = perform_category(category, statement[2]) # array ['int', True]
            
            if response[1] == True:
                results.append(response[0])  # only parsed integers
                break
    
    return results  
  


greetings = ["Hello", "Hi", "Goog day", "Good morning", 'Greetings', 'Hey', 'Whats up',
'good morning', 'good day', 'good evening', 'goog afternoon']

actions = ["Sell", "Buy", "Rent"] #"I want buy", "I want sell", 
actions_parse = {'buy': ['buy'], 'sell':['sell'], 'rent':['rent']} # [('buy', 100), ('rent', 33), ('sell', 0)]

beds = ["bed", "beds", "bedroom", 'bedrooms']
baths = ["bath", "baths", "bathrooms", "bathroom"]
price = ["min price", "max price", "price", "budget", 'between', 'K', 'Million', 'M', '$']
address = ["address", "street", "state", "placement"]

sets = {'greetings' : greetings, 'actions' : actions,
		'beds' : beds, 'baths' : baths, 'price' : price}




# TODO
# if asked count of beds - answer number - it is good
# double questions - beds and baths ?
# min price, max price, between price
# parse address CITY, STATE - Austin, TX
# Differ messages from agent and user
