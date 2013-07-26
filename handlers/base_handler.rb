class BaseHandler 

  # Return true if message will be handle
  #
  # ==== Attributes
  #
  # * +activity_type+ - Message type from stream API
  def supports? (activity_type)
    return false
  end

  # Display activity in console for debugging purpose
  #
  # ==== Attributes
  #
  # * +message+ - Message from stream API
  def handle(message)
  end

  # Push content to Flowdoc chat
  #
  # ==== Attributes
  #
  # * +flow_api_token+ - API Token of your target flow
  # * +content+ - The chat message to push
  def say(flow_api_token, content)
    begin
      flow = Flowdock::Flow.new(:api_token => flow_api_token, :external_user_name => $username)
      flow.push_to_chat(:content => content)
      puts "Successfully pushed to Flowdok API"
    rescue
      warn "Error while pushing to flowdock"
    end
  end

  # Push content to Flowdoc team inbox
  #
  # ==== Attributes
  #
  # * +flow_api_token+ - API Token of your target flow
  # * +subject+ - Message subject which appear as title
  # * +content+ - The chat message to push
  # * +tags+ - The chat message to push
  # * +link+ - The chat message to push
  def team(flow_api_token, subject, content, tags, link)
    begin
      flow = Flowdock::Flow.new(:api_token => flow_api_token, :external_user_name => $username)
      flow.push_to_team_inbox(
        :subject => subject,
        :content => content.html_safe,
        :tags => tags,
        :link => link
      )
    rescue

    end    
  end

  # Get flow API token from a flow label
  #
  # ==== Attributes
  #
  # * +flow+ - The flow name from stream API (=organization:flowname)
  def get_token(flow)
    return $flows[flow.gsub("#{$organization}:", "")]
  end

  # Get the username from Flowdock API (not implemented in flowdock gem yet)
  #
  # ==== Attributes
  #
  # * +user_id+ - The user ID from stream API
  def get_username(user_id)
    uri = URI.parse("https://api.flowdock.com/users/#{user_id}")
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      request = Net::HTTP::Get.new uri.request_uri
      request.basic_auth $token, 'secret'
      response = http.request request 
      data  = JSON.parse(response.body)
      return data["nick"]
    end
  end


end
