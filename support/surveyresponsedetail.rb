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
