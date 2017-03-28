from textblob import TextBlob
from textblob.np_extractors import ConllExtractor
from agent import *
import code

def perform(params):
	groups = {'greetings':[], 'actions':[], 'beds':[], 'baths':[], 'price':[]}
	answers = {'greetings':[], 'actions':[], 'beds':[], 'baths':[], 'price':[]}
	result = []
	message = params['message']
	agent = params['agent']

	blob = TextBlob(message)

	if len(blob.words) > 1:
	    messages = blob.ngrams(n=2) + blob.ngrams(n=3)
	else:
	    messages = blob.ngrams(n=1)

	statements = analyze_messages(messages, sets, fuzz.partial_ratio)
	statements_hash = group_by_category(statements, groups)

	for category, statements in statements_hash.iteritems():
	    response = answer_category(category, statements) # array of parsed integers or data

	    if len(response) > 0:
		    sentence = wrap_category(category, response[0])
		    #answers[category].append(tuple([category, sentence])) # add to answers Category ('greetings', 'Smith')
		    result.append(sentence)

	if len(result) == 0:
	    result = result.append(default_response())

	return ' '.join([str(x) for x in result])
