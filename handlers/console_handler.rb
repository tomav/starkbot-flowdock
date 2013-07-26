class ConsoleHandler 

  # Return true if message will be handle
  #
  # ==== Attributes
  #
  # * +activity_type+ - Message type from stream API
  def supports? (activity_type)
    return true
  end

  # Display activity in console for debugging purpose
  #
  # ==== Attributes
  #
  # * +message+ - Message from stream API
  def handle(message)
    if message["event"] == "message"
      puts "#{message['event']} => #{message['user']}: #{message['content']}"
    elsif message["event"] == "comment"
      puts "#{message['event']} => #{message['user']}: #{message['content']['text']}"
    else
      puts "#{message['event']} => #{message['id']} on #{message['flow']}"
    end
  end

end
