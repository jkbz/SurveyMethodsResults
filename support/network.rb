# network.rb

require 'rest-client'

def command(url)
  response = RestClient.get url

  return response unless ![200,204].include?(response.code)
  error(response)
end

def error(response)
  puts "ERROR: #{response.code}"
  puts response  
end
