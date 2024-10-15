<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather Checker</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .weather-container {
            background-color: #f0f0f0;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 400px;
        }
        h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 20px;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            font-size: 18px;
            border-radius: 8px;
            border: 1px solid #ccc;
            margin-bottom: 20px;
            outline: none;
        }
        button {
            background-color: #0072ff;
            color: #fff;
            border: none;
            padding: 12px 20px;
            font-size: 18px;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #005bb5;
        }
        .weather-result {
            margin-top: 20px;
            background-color: #fff;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            color: #333;
            display: none;
        }
        .weather-result p {
            margin: 10px 0;
            font-size: 18px;
        }
        .error-message {
            color: red;
            font-size: 16px;
            display: none;
        }
    </style>
     <script>
        var getWeather = () => {
            const city = document.getElementById('city').value;
            const apiUrl = "${api_url}";  // Directly reference api_url without braces
    
            fetch(apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ city: city })
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                if (data.city) {
                    const weatherInfo = 
                        '<p><strong>City:</strong> ' + data.city + '</p>' +
                        '<p><strong>Temperature:</strong> ' + data.temperature + ' °C</p>' +
                        '<p><strong>Weather:</strong> ' + data.weather + '</p>';
                    
                    document.getElementById('weather-result').innerHTML = weatherInfo;
                    document.getElementById('weather-result').style.display = 'block';
                    document.getElementById('error-message').style.display = 'none';
                } else {
                    document.getElementById('weather-result').style.display = 'none';
                    document.getElementById('error-message').textContent = 'City not found. Please try again.';
                    document.getElementById('error-message').style.display = 'block';
                }
            })
            .catch(error => {
                console.error('Error fetching the weather data:', error);
                document.getElementById('error-message').textContent = 'Something went wrong. Please try again.';
                document.getElementById('error-message').style.display = 'block';
            });
        }
    </script>
</head>
<body>
    <div class="weather-container">
        <h1>Check the Weather</h1>
        <input type="text" id="city" placeholder="Enter city name..." />
        <button type="button" onclick="getWeather()">Get Weather</button>

        <!-- Weather result section -->
        <div class="weather-result" id="weather-result">
            <!-- Weather data will appear here -->
        </div>

        <!-- Error message section -->
        <p id="error-message" class="error-message"></p>
    </div>
</body>
</html>
