################################
## Created by Ilya Stetsovsky ##
################################

require 'json'
require 'net/http'

#define city for which weather details are needed
city='London'

#call the api with required parameters
uri = URI('http://api.worldweatheronline.com/free/v2/weather.ashx/')
params = { :q => city, :format => 'json', :num_of_days => 5, :key => 'd80356f89110aaa7d1cf876ab0465d5a97e9c208' }
uri.query = URI.encode_www_form(params)

#store response of API 
resp = Net::HTTP.get_response(uri)

#store api response header status and body
code = resp.code
data = resp.body

#parse through response body
result = JSON.parse(data)

#function to validate visibility in desired city
def fvisibility(vresult)

	#get value for visibility from api body
	visibility = vresult["data"]["current_condition"][0]["visibility"]

	#get expected visibility from file
	expected = File.open("expected_visibility.txt", "r")

	#validate that visibility returned from api matches the expected result
	if visibility = expected.readlines then
		puts "--------"
		puts "Test 1 (Pass): Visibility of #{visibility} is correct!"
	else	
		puts "--------"
		puts "Test 1 (Fail): Visibility of #{visibility} is not correct!"
    
        end

end

#function to validate temperature conversion
def fconversion(vresult)

	#pick up temps from api body
	celsius = vresult["data"]["current_condition"][0]["temp_C"]
	fahrenheit = vresult["data"]["current_condition"][0]["temp_F"]

	#define expected conversion formula
	conversion2F = celsius.to_i * 1.8 + 32
	rounded_conversion = conversion2F.round

	#validate that convervion from celsius to fahrenheit is done correctly by api
	if rounded_conversion = fahrenheit.to_i then
		puts "--------"
		puts "Test 2 (Pass): Conversion from Celsius to Fahrenheit is working correctly!"
	else
		puts "--------"
		puts "Test 2 (Pass): Conversion from Celsius to Fahrenheit is not working correctly!"
	end
end

#function to validate weather response for correct city
def fcitycheck(vresult,vcity)

	#pick up city and country from api response body
	city = vresult["data"]["request"][0]["query"]

	#remove country from api response leaving only the city
	truncatedcity=city[0,vcity.length]
	
	#validate that api response is for correct city
	if city = truncatedcity then
		puts "--------"
		puts "Test 3 (Pass): Weather for #{city} is correct!"
	else
		puts "--------"
		puts "Test 3 (Pass): Weather for #{city} is not correct!"
	end
	
end

#call functions only if api response is OK
if code = 200 then 
       
	
        puts "--------"
	puts "We have a successful API Response!"
	puts "--------"
	puts code

	#call the functions
	fvisibility result
	fconversion result
	fcitycheck result, city
	
else
	puts "Something went wrong!"
end

