import json

def lambda_handler(event, context):
    
    jenkins_test = event['jenkins']
    # TODO implement
    return {
        'statusCode': 200,
        'jenkins_variable': jenkins_test,
        'body': json.dumps('Hello from Lambda!')
    }