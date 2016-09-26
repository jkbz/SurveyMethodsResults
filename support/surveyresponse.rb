require 'json'
require_relative 'surveyresponsedetail'

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
