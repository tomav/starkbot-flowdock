class HelloHandler < BaseHandler

  # Return true if message will be handle
  #
  # ==== Attributes
  #
  # * +activity_type+ - Message type from stream API
  def supports? (activity_type)
    if activity_type == "message" 
      return true
    # elsif activity_type == "comment" 
    #   return true
    else
      return false
    end
  end

  # Return a content for a matching pattern (autoreply)
  #
  # ==== Attributes
  #
  # * +message+ - Message from stream API
  def handle(message)
    if message["content"].match(/^hello/i) && message["user"] != "0"
      say(get_token(message['flow']), "Hello #{get_username(message['user'])}!")
    end
  end

end
