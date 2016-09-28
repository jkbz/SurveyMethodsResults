require 'json'
require_relative 'network'

class Survey
	
  def initialize(survey_id)
    @id = survey_id
    @title = nil
    @language = nil
    @num_responses = nil
    @responses = []

    load_summary
  end

  def get_site_url(category,page,survey_id)
    ## Format: https://api.surveymethods.com/v1/{login_id}/{api_key}/_category_/{survey_code}/_page_

    url = SITEURL + USERNAME + '/' + TOKEN + '/' + category + '/' + survey_id + '/' + page
    return url
  end
  
  def load_summary
    category = 'surveys'
    page = ''
    
    url = get_site_url(category,page,@id)
    response = command(url)

    survey_summary = JSON.parse(response)['survey']

    set_title(survey_summary['title'])
    set_responses(survey_summary['response_count'])
    set_language(@title.split(" ")[3])
  end

  def load_responses
    category = 'responses'
    page = 'summary'
    
    url = get_site_url(category,page,@id)
    responses = command(url)

    responses = JSON.parse(responses)['pages'][0]['responses']

    responses.each do |response|
      survey_response = SurveyResponse.new(@id,response)

      @responses.push(survey_response)
    end
  end

  def print_survey()
    puts "#{@language}: #{@num_responses} response(s)"
    puts print_response_details()
  end

  def print_response_details()
    
  end

  def id()
    @id
  end

  def title()
    @title
  end

  def language()
    @language
  end

  def responses()
    @num_responses
  end

  def set_title(title)
    @title = title
  end

  def set_language(language_key)
    @language = lookup_language(language_key)
  end

  def set_responses(responses)
    @num_responses = responses
  end

  def lookup_language(key)
    case key.upcase
    when 'DA'
      'Danish'
    when 'CZ'
      'Czech'
    when 'CHT'
      'Chinese-T'
    when 'ES'
      'Spanish'
    when 'EN'
      'Engish'
    when 'FR'
      'French'
    when 'CHS'
      'Chinese-S'
    when 'NL'
      'Dutch'
    when 'JP'
      'Japanese'
    when 'IT'
      'Italian'
    when 'KO'
      'Korean'
    when 'PL'
      'Polish'
    when 'PT'
      'Portuguese'
    when 'RU'
      'Russian'
    when 'TR'
      'Turkish'
    when 'DE'
      'German'
    else
      'Unknown'
    end
  end
  
end

class SurveyResponse < Survey

  def initialize(survey_id,response_json)
    @id = survey_id
    @code = response_json['code']
    @date = response_json['date_started']
    @question = nil
    @details = []
    @comments = nil 

    get_response_details()
  end

  def get_response_details
    category = 'responses'
    page = 'detail' + '/' + @code

    url = get_site_url(category,page,@id)
    details = command(url)

    details = JSON.parse(details)['questions']

    puts "\n"
    puts @date

    details.each do |row|
      survey_detail = SurveyResponseDetail.new(row)
      survey_detail.print_question
      @details.push(survey_detail)
    end
  end

  def code
    @code
  end

  def date()
    @date
  end

end

class SurveyResponseDetail

  def initialize(response_hash)
    set_question(response_hash['question_text'])
    set_answer(response_hash['answer'][0]['value'])

    if response_hash['answer'][0].length > 1
      set_comments(response_hash['answer'][0]['additional_comments']['value']) 
    else
      set_comments(nil)
    end
  end

  def print_question
    if @answer != "" && @answer != " " && @answer != nil
      puts "#{question} \n  Answer: #{@answer}" 
    end
    
    if @comments != "" && @comments != " " && @comments != nil
      puts "  Comments: #{@comments}" 
    end
  end
  
  def question
    @question
  end

  def answer
    @answer
  end

  def comments
    @comments
  end

  def set_question(question)
    @question = question
  end

  def set_answer(answer)
    @answer = answer
  end

  def set_comments(comments)
    @comments = comments
  end  
  
end
