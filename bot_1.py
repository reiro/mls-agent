import sys
from textblob import TextBlob
from textblob.np_extractors import ConllExtractor
from fuzzywuzzy import fuzz
from fuzzywuzzy import process
from itertools import groupby
import nltk

class Agent:
    def __init__(self):
        self.answers = []


classes = ['greeting', 'select_type', 'beds', 'baths', 'price']

greetings = ["Hello", "Hi", "Goog day", "Good morning", 'Greetings', 'Hey', 'Whats up',
'good morning', 'good day', 'good evening', 'goog afternoon']

actions = ["I want buy", "I want sell", "sell", "Buy", "Rent"]

beds = ["bed", "beds", 'one bed', 'two beds', 'three beds', 'four beds']
baths = ["one bath", "two baths"]
price = ["min price", "max price", "price", "budget"]

sets = {'greetings' : greetings, 'actions' : actions, 
		'beds' : beds, 'baths' : baths, 'price' : price}

#run puthon script as service on ubuntu

def get_max_score(msg, set):
	max_score = 0
	for phrase in set:
		score = fuzz.partial_ratio(msg, phrase)
		if score > max_score:
			max_score = score
	return max_score

def get_avg_score(msg, set):
	avg_score = 0
	for phrase in set:
		score = fuzz.ratio(msg, phrase)
		avg_score += score
	avg_score = avg_score / len(set)
	return avg_score

def get_msg_to_responce(messages, sets):
	result = []
	for msg in messages:
		msg = " ".join(map(str, msg))
		scores = []
		for key, set in sets.iteritems():
			best_score = process.extractOne(msg, set, scorer=fuzz.partial_ratio)[1]
			scores.append(tuple([key, best_score]))

		top_set = sorted(scores, key=lambda (k): (k[1]), reverse=True)[0]
		top_set += (msg,)
		result.append(top_set)

	return result

def default_response(statement):
    return 'Try some other message, please!'

def greetings_response(statement):
    return 'Hello customer!'

def actions_response(statement):
	# tokens = nltk.word_tokenize(statement[2])
	# for token in tokens:
		# process.extractOne(token, ['active'], scorer=fuzz.partial_ratio)[1]
	

    return 'Ok. I will sell you a home.'

def beds_response(statement):
    tokens = nltk.word_tokenize(statement[2])
    tagged = nltk.pos_tag(tokens)

    for tag in tagged:
    	if tag[1] == 'CD':
    		beds = tag[0]

    if beds:
    	result = "You want home with " + beds + " beds"
    else:
   		result = ''

    return result	

def get_responce(statement):
    switcher = {
        'greetings': 'greetings_response',
        'actions': 'actions_response',
        'beds': 'beds_response',
        'baths' : 'trhree'
    }
    func = switcher.get(statement[0], '')
    return globals()[func](statement)

message = " ".join(sys.argv[1::])
result = ''
a = Agent()

blob = TextBlob(message)
if len(blob.words) > 1:
    messages = blob.ngrams(n=2)
else:
    messages = blob.ngrams(n=1)

statements = get_msg_to_responce(messages, sets)

for statement in sorted(statements, key=lambda (k): (k[1]), reverse=True):
    if statement[1] > 90 and not [item for item in a.answers if item[0] == statement[0]]:
        response = get_responce(statement)
        a.answers.append(tuple([statement[0], response]))
        result = result + " " + response

    if len(a.answers) == 0:
        result = default_response()

print result[1:]
