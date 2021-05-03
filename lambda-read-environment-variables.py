import json
import mysql.connector
import os
import boto3
# mysql settings
# Create a Secrets Manager client
session = boto3.session.Session()
client = session.client(
            service_name='secretsmanager',
            region_name=os.environ['MY_AWS_REGION']
        )
mysql_username = os.environ['MYSQL_USERNAME']
def lambda_handler(event, context):
    get_secret_value_response = client.get_secret_value(
                SecretId=os.environ['SECRET_NAME']
            )
    print(get_secret_value_response)
    mysql_username_secret=get_secret_value_response['SecretString']
    print(mysql_username_secret)
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
