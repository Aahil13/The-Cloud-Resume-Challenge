import json
import boto3

dynamodb = boto3.client('dynamodb')
table_name = 'visitor_count'

def lambda_handler(event, context):
    if event['httpMethod'] == 'OPTIONS':
        # Handle preflight request
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type,Authorization'
            }
        }
    if event['httpMethod'] == 'GET':
        try:
            # Increment the visitor count in DynamoDB
            response = dynamodb.update_item(
                TableName=table_name,
                Key={'CounterID': {'S': '1'}},
                UpdateExpression='SET VisitorCount = VisitorCount + :val',
                ExpressionAttributeValues={':val': {'N': '1'}},
                ReturnValues='UPDATED_NEW'
            )
            updated_count = response['Attributes']['VisitorCount']
            
            # Return the numeric value directly in the response body
            return {
                'statusCode': 200,
                'body': json.dumps(updated_count),
                'headers': {
                    'Content-Type': 'application/json'
                }
            }
        except Exception as e:
            return {
                'statusCode': 500,
                'body': json.dumps({'error': str(e)})
            }
