class ReplyHandler < BaseHandler

  # Require the key/values
  require_relative "reply_handler_config.rb"

  # Return true if message will be handle
  #
  # ==== Attributes
  #
  # * +activity_type+ - Message type from stream API
  def supports? (activity_type)
    if activity_type == "message" 
      return true
    elsif activity_type == "comment"
      return true
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
    @@reply_content.each do |key,val|
      if message['event'] == "message"
        if message["content"].downcase.include? key
          say(get_token(message['flow']), val)
        end
      elsif message['event'] == "comment"
        if message['content']['text'].downcase.include? key
          say(get_token(message['flow']), val)
        end
      else
      end
    end
  end

end
