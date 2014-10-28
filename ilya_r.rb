require 'json'
require 'net/http'

url = 'http://api.worldweatheronline.com/free/v2/weather.ashx?q=London&format=json&num_of_days=5&key=d80356f89110aaa7d1cf876ab0465d5a97e9c208'

resp = Net::HTTP.get_response(URI.parse(url))

data = resp.body
code = resp.code
result = JSON.parse(data)

expected = File.open("expected_visibility.txt", "r")

if code = 200 then 
        
        puts "--------"
	puts code
        puts "--------"
	puts "We have a successful API Response!"
	puts "--------"

	visibility = result["data"]["current_condition"][0]["visibility"]
	
	if visibility = expected.readlines then
		puts "Visibility of #{visibility} is correct!"
	else	
		puts "Visibility of #{visibility} is not correct!"
    
        end
else
	puts "Something went wrong!"
end

