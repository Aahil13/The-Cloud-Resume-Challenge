import json
import boto3
import logging

dynamodb = boto3.client('dynamodb')
table_name = 'resume_visitor_count'

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Received event: " + json.dumps(event))

    if event['httpMethod'] == 'GET':
        try:
            response = dynamodb.get_item(
                TableName=table_name,
                Key={'CounterID': {'S': '1'}}
            )
            item = response.get('Item')
            if item:
                count = item.get('VisitorCount', {'N': '0'})  # Update to the correct attribute name
            else:
                count = 0
            return {
                'statusCode': 200,
                'body': json.dumps({'visitor_count': count})
            }
        except Exception as e:
            return {
                'statusCode': 500,
                'body': json.dumps({'error': str(e)})
            }

    if event['httpMethod'] == 'POST':
        try:
            # Use Expression Attribute Names to avoid using the reserved keyword
            update_expression = 'SET #attrName = #attrName + :val'
            expression_attribute_names = {'#attrName': 'VisitorCount'}  # Map the reserved keyword to a placeholder name
            expression_attribute_values = {':val': {'N': '1'}}
            response = dynamodb.update_item(
                TableName=table_name,
                Key={'CounterID': {'S': '1'}},
                UpdateExpression=update_expression,
                ExpressionAttributeNames=expression_attribute_names,
                ExpressionAttributeValues=expression_attribute_values,
                ReturnValues='UPDATED_NEW'
            )
            count = int(response['Attributes']['VisitorCount']['N'])  # Update to the correct attribute name
            return {
                'statusCode': 200,
                'body': json.dumps({'visitor_count': count})
            }
        except Exception as e:
            return {
                'statusCode': 500,
                'body': json.dumps({'error': str(e)})
            }
    
    return {
        'statusCode': 400,
        'body': json.dumps({'error': 'Invalid HTTP Method'})
    }
