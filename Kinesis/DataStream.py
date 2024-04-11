import base64
import json

print('Executing DataStream... ')

def stream_hendler(event, context):
    for record in event['Records']:
        print(record['kiensis']['data'])
