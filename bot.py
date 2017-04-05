from textblob import TextBlob
from textblob.np_extractors import ConllExtractor
from agent import *
import code

def get_blob_messages(message):
	blob = TextBlob(message)

	if len(blob.words) > 1:
		messages = blob.ngrams(n=2) + blob.ngrams(n=3)
	else:
		messages = blob.ngrams(n=1)

	return messages

def prepare_result(result):
	return ' '.join([str(x) for x in result])

def greetings_ensure(result, agent):
	if agent['has_greetings'] == False:
		result.insert(0, greetings_wrap(''))

def perform(params):
	categories = ['greetings', 'actions', 'beds', 'baths', 'price', 'address']
	groups = {'greetings':[], 'actions':[], 'beds':[], 'baths':[], 'price':[], 'address':[]}
	result = []
	agent = params['agent']
	messages = get_blob_messages(params['message'])

	statements = analyze_messages(messages, sets, fuzz.partial_ratio)
	statements_hash = group_by_category(statements, groups)

	#code.interact(local=dict(globals(), **locals()))
	print statements_hash

	for category in categories:
		statements = statements_hash[category] # array of typles ('greetings', 100, 'Good day')

		if statements:
			response = answer_category(category, statements) # array of parsed integers or data

			if len(response) > 0 and agent['has_' + category] == False:
				agent[category] = response[0]
				agent['has_' + category] = True

				sentence = wrap_category(category, response[0]) # add text to parsed params
				result.append(sentence)

	for category in categories:
		if agent['has_' + category] == False:
			question = questions_category(category)
			break

	question = question

	greetings_ensure(result, agent)	
			
  	res_message = prepare_result(result)

  	print question

	return {'message': res_message, 'question': question, 'agent': agent}
