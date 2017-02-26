#!/usr/bin/env python

import requests, sys
from os import environ
from datetime import datetime

token = environ['TOKEN']
sha = environ['TRAVIS_COMMIT']
tag = environ['BUILD_TAG']
message = 'Travis build #' + environ['TRAVIS_BUILD_NUMBER'] + ' pushed a tag!'
tag_type = 'commit'
base_url = 'https://api.github.com/repos/yashdsaraf/bb-bot/git'
tags_url = base_url + '/tags'
refs_url = base_url + '/refs'
ref = 'refs/tags/' + tag
tagger = {
	'name': 'Travis',
	'email': 'travis@travis-ci.org',
	'date': datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S%z+00:00')
}
base_header = {
	'Authorization': 'token ' + token
}

print('Creating tag ' + tag + ' for commit ' + sha + '...')

# Create a tag
headers = {
	'tag': tag,
	'message': message,
	'object': sha,
	'type': tag_type,
	'tagger': tagger
}

response = requests.post(tags_url, headers=base_header, json=headers)
data = response.json()

if response.status_code != 201:
	print('Error ' + str(response.status_code) + ': ' + data['message'])
	sys.exit(1)

# Create a ref to the above tag
headers = {
	'ref': ref,
	'sha': data['sha']
}

response = requests.post(refs_url, headers=base_header, json=headers)
data = response.json()

if response.status_code != 201:
	print('Error ' + str(response.status_code) + ': ' + data['message'])
	print(headers)
	sys.exit(1)