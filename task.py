import boto3
import json
client = boto3.client('ec2')
def monitor():
    try: 
        response = client.monitor_instances(
        InstanceIds=[
            'i-0a97a4f470c7ef8d2',
            ],
            DryRun=False
        )
        print(json.dumps(response, indent=2))
    except Exception as e:
        print(f"Error: {e}")

monitor()