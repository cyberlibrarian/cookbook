#!env python
#

import os
from random import randint
from time import sleep
import getpass
import digitalocean as do

# TODO get API optionally from command line arg but keep these methods
# Get the DO API Token securely
if 'DO_TOKEN' in os.environ.keys():
    token = os.getenv('DO_TOKEN')
else:
    token = getpass.getpass('Enter your Digital Ocean token:')

# Create a DO API manager object, used to get information about our account and droplets
try:
    manager = do.Manager(token=token)
except Exception as e:
    print(token)
    print(f'Err: {e}')
	
# you can add 'tag_name="tagname"' in the paramaters to search
#try:
#    droplets = manager.get_all_droplets()
#except Exception as e:
#    print(f'Err: {e}')
	

id=288429968
# Configure our droplet now that all configuration items are defined
try:
    droplet = do.Droplet(id=id, token=token)
except Exception as e:
    print(f'Err: {e}')

droplet.load()

try:
    droplet.destroy()
except Exception as e:
    print(f'Err: {e}')
    
# Let's do a quick check to see if the droplet has been destroyed
actions = droplet.get_actions()
actions[0].wait(5) # wait for the droplet destroy to complete, checking every 5 seconds
print(actions)