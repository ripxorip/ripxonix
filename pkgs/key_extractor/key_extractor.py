#!/usr/bin/env python3.8
import os
import json

user_home = os.environ['HOME']
os.system(f'mkdir -p {user_home}/dev/keys')

# Get the output of bw login and save the session key to a variable
session_key = os.popen('bw login --raw').read().strip()

raw_out = os.popen(f'BW_SESSION={session_key} bw get item agenix_private_key').read()
json_out = json.loads(raw_out)
key_data = json_out['notes']

with open(f'{user_home}/dev/keys/agenix', "w") as key_file:
    key_file.write(key_data)

os.system(f'chmod 600 {user_home}/dev/keys/agenix')

raw_out = os.popen(f'BW_SESSION={session_key} bw get item ssh_key_private').read()
json_out = json.loads(raw_out)
key_data = json_out['notes']

with open(f'{user_home}/.ssh/ripxorip', "w") as key_file:
    key_file.write(key_data)

os.system(f'chmod 600 {user_home}/.ssh/ripxorip')

os.system("bw logout")
