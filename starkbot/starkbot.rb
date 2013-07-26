class StarkBot

  @@handlers      = []

  # Starkbot constructor
  #
  # ==== Attributes
  #
  # * +username+ - Bot's nickname
  # * +token+ - Your personal token (= not flow token)
  # * +organization+ - Organization name that prefixes every flow (organization/flow)
  # * +flows+ - Hash of each flow the bot will listen to, with name and flow api token
  # * +plugins+ Array of each Class os plugin to load
  def initialize(username, token, organization, flows)
    @username, @token, @organization, @flows = username, token, organization, flows
    puts "##"
    puts "## Starting #{@username} @ #{@organization}"
    puts "##"
  end

  # Generate flows map
  #
  # ==== Attributes
  #
  # * +flows+ - Hash with +flow_name => flow_api+
  #
  def compile_flows(flows)
    flows.each do |key,value|
      key = Flowdock::Flow.new(:api_token => value, :external_user_name => @username)
    end
  end

  # Connect the bot the flowdock stream API to listen to the flows activity
  def connect

    compile_flows(@flows)

    puts "## Connecting to stream..."
    http = EventMachine::HttpRequest.new("https://stream.flowdock.com/flows?filter=#{@flows.map { |k,v| "#{@organization}/#{k}"  }.join(",")}&active=true")
    EventMachine.run do
      s = http.get(
        :head => { 'Authorization' => [@token, ''], 'accept' => 'application/json'},
        :keepalive => true, :connect_timeout => 0, :inactivity_timeout => 0
      )

      s.callback do
        puts "Connected to stream."
        puts "Reponse code is #{s.response_header.status}"
      end

      s.errback do
        warn "Disconnected."
        warn "Try to reconnect."
        self.connect
      end

      buffer = ""
      s.stream do |chunk|
        buffer << chunk
        while line = buffer.slice!(/.+\r\n/)
          handle_message JSON.parse(line)
        end
      end
    end
  end

  # Handler (plugins) loader
  #
  # ==== Attributes
  #
  # * +new_handler+ - handler object to load
  def register_handler(new_handler)
    @@handlers << new_handler
  end

  # Plugin loader
  #
  # ==== Attributes
  #
  # * +handler+ - handler class to load
  def load(plugins)
    puts "## Initializing modules:"
    plugins.each do |handler|
      puts "## => #{handler}.new => loading handlers/#{handler.to_underscore}.rb"
      require_relative "../handlers/#{handler.to_underscore}.rb"
      register_handler eval(handler).new
    end
    puts "##"
  end

  private

  # Send the message to each registered handler
  #
  # ==== Attributes
  #
  # * +msg+ - The full flowdock message from stream API
  def handle_message(msg)
    @@handlers.each do |handler|
      response = handler.handle msg if handler.supports? msg['event']
    end
  end

end

