#!/usr/bin/env python3.8
import os
import json

user_home = os.environ['HOME']
os.system(f'mkdir -p {user_home}/dev/keys')

raw_out = os.popen("bw get item agenix_private_key").read()
json_out = json.loads(raw_out)
key_data = json_out['notes']

with open(f'{user_home}/dev/keys/agenix', "w") as key_file:
    key_file.write(key_data)

os.system(f'chmod 600 {user_home}/dev/keys/agenix')