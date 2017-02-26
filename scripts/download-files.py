#!/usr/bin/env python3

import json, requests, sys
from concurrent.futures import ThreadPoolExecutor
from zipfile import ZipFile
from os import environ, remove
from time import sleep

token = environ['TOKEN']
tag = environ['BUILD_TAG']
ver = environ['VER']
url = 'https://api.github.com/repos/yashdsaraf/bb-bot/releases/tags/' + tag

headers = {
	'Authorisation': 'token ' + token
}

archs = ('ARM','X86','MIPS')

def download(arch):
	file = 'Busybox-' + ver + '-' + arch + '.zip'
	print('Downloading ' + file + '...')
	data = requests.get(url, headers=headers).json()

	if 'url' not in data:
		print("Invalid tag found!")
		sys.exit()

	tag_url = data['url'] + '/assets'
	asset_list = requests.get(tag_url, headers).json()

	while True:
		for asset in asset_list:
			if asset['name'] == file:
				asset_url = asset['url']
				break
		else:
			sleep(5)
			continue
		break

	headers['Accept'] = 'application/octet-stream'
	response = requests.get(asset_url, headers=headers)

	if response.status_code == 200:
		with open(file, 'wb') as fd:
			for chunk in response.iter_content(chunk_size=128):
				fd.write(chunk)
	elif response.status_code == 302:
		response = requests.get(response.headers.get('location'), headers=headers)
		with open(file, 'wb') as fd:
			for chunk in response.iter_content(chunk_size=128):
				fd.write(chunk)

	with ZipFile(file) as zipfile:
		names = filter(lambda x: 'META-INF' not in x, zipfile.namelist())
		zipfile.extractall('../bbx/Bins/' + arch.lower(), names)

	remove(file)

with ThreadPoolExecutor() as executor:
	executor.map(download, archs)