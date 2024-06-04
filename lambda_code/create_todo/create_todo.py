import json
import boto3

# Create the DynamoDB client
dynamodb = boto3.client('dynamodb')
# Set the name of the DynamoDB table
table_name = 'todo_app_93u45_todo_table'
def lambda_handler(event, context):

   # Parse the JSON data passed to the Lambda function
   data = json.loads(event['body']) 
   
   # Extract the values from the data
   id = data['id']
   name = data['name']
   content = data['content']

   # Create an item to put in the DynamoDB table
   item = {
      'id': {'S': id},
      'Name': {'S': name},
      'Content': {'S': content}
   }
   
   # Put the item in the DynamoDB table
   response = dynamodb.put_item(
      TableName=table_name,
      Item=item
   )
   
   # Return a response indicating success
   return {
      'statusCode': 200,
      'body': json.dumps('Item added to DynamoDB table')
   }