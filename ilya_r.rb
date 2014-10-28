require 'json'
require 'net/http'

#call weather API
url = 'http://api.worldweatheronline.com/free/v2/weather.ashx?q=London&format=json&num_of_days=5&key=d80356f89110aaa7d1cf876ab0465d5a97e9c208'

#store response of API 
resp = Net::HTTP.get_response(URI.parse(url))

#store api response header status and body
code = resp.code
data = resp.body

#parse through response body
result = JSON.parse(data)

#get expected visibility from file
expected = File.open("expected_visibility.txt", "r")

#validate response header status
if code = 200 then 
        
        puts "--------"
	puts code
        puts "--------"
	puts "We have a successful API Response!"
	puts "--------"

	visibility = result["data"]["current_condition"][0]["visibility"]
	celsius = result["data"]["current_condition"][0]["temp_C"]
	fahrenheit = result["data"]["current_condition"][0]["temp_F"]
	conversion2F = celsius.to_i * 1.8 + 32
	rounded_conversion = conversion2F.round
	
	#validate that visibility returned from api matches the expected result
	if visibility = expected.readlines then
		puts "Visibility of #{visibility} is correct!"
	else	
		puts "Visibility of #{visibility} is not correct!"
    
        end

	#validate that convervion from celsius to fahrenheit is done correctly by api
	if rounded_conversion = fahrenheit.to_i then
		puts "--------"
		puts "Conversion from Celsius to Fahrenheit is working correctly!"
	else
		puts "--------"
		puts "Conversion from Celsius to Fahrenheit is not working correctly!"
	end
else
	puts "Something went wrong!"
end

