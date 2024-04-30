
import boto3
from datetime import datetime

def lambda_handler(event, context):
    send_emails()

def send_emails():
    ses_client = boto3.client('ses', region_name='eu-west-1')
    sender_email = 'asmaa.a.mohamed02@gmail.com'
    recipient_email = 'asmaa.a.mohamed02@gmail.com'
    subject = 'State File Changed'
    message = f"Dear {recipient_email},\n\nA change in the state file occurred successfully at {datetime.now().isoformat()}."

    response = ses_client.send_email(
        Source=sender_email,
        Destination={
            'ToAddresses': [recipient_email]
        },
        Message={
            'Subject': {
                'Data': subject
            },
            'Body': {
                'Text': {
                    'Data': message
                }
            }
        }
    )

    print(f"Email sent to {recipient_email}: {response['MessageId']}")