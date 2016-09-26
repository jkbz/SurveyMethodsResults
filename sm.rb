require 'json'
require 'terminal-notifier'

require_relative 'api_auth'
require_relative 'support/network'
require_relative 'support/survey'

SITEURL = 'https://api.surveymethods.com/v1/'

################# Parameters #################

@username = get_api_username
@token    = get_api_token

@survey_list = get_survey_id

################## Code #################

survey_summary_list = Array.new()

@survey_list.each do |survey_id|
  survey = Survey.new(survey_id)
  survey_summary_list.push(survey)
end

survey_summary_list.each do |survey|
  if survey.responses > 0
    puts "\n#{survey.language}: #{survey.responses} response(s)"
    
    survey.load_responses
  end
end

puts "\nNo responses:"
survey_summary_list.each do |survey|
  puts " #{survey.language}" unless survey.responses > 0
end
