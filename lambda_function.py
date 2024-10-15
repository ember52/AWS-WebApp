import json
import boto3
import os
import urllib.parse
import urllib.request
from decimal import Decimal

# Create a DynamoDB object using the AWS SDK
dynamodb = boto3.resource('dynamodb')
# Use the DynamoDB object to select our table
table = dynamodb.Table('WeatherChecker')

def lambda_handler(event, context):
    city = event['city']
    api_key = os.environ['WEATHER_API_KEY']
    
    # Fetch weather data from OpenWeatherMap
    weather_url = f"http://api.openweathermap.org/data/2.5/weather?q={urllib.parse.quote(city)}&appid={api_key}&units=metric"
    
    try:
        response = urllib.request.urlopen(weather_url)
        weather_data = json.loads(response.read())
        
        # Extract necessary information
        temperature = weather_data['main']['temp']
        weather_description = weather_data['weather'][0]['description']
        current_time = weather_data['dt']

        item_id = f"{city}_{current_time}"

        # Write result and time to the DynamoDB table
        response = table.put_item(
            Item={
                'ID': item_id,
                'City': city,
                'Weather': weather_description,
                'Temperature': Decimal(str(temperature)),
                'Time': Decimal(current_time)
            }
        )

        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': {
                'city': city,
                'weather': weather_description,
                'temperature': float(temperature)  # Changed from Decimal to float
            }  # Return as JSON object
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': {
                'error': f"An error occurred: {str(e)}"
            }
        }
