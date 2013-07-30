class RconHandler < BaseHandler

  # Require parameters
  require_relative "rcon_handler_config.rb"

  attr_reader :rcon_admins

  # Return true if message will be handle
  #
  # ==== Attributes
  #
  # * +activity_type+ - Message type from stream API
  def supports? (activity_type)
    if activity_type == "message"
      return true
    else
      return false
    end
  end

  # Get and return server status when "!players" is triggered
  #
  # ==== Attributes
  #
  # * +message+ - Message from stream API
  def handle(message)
    if message["content"].include? "!players"
      @@hlds_servers.each do |s|
        ip, port, is_hltv, pwd = s[0], s[1], s[2], s[3]
        content = get_status(ip, port, is_hltv, pwd)
        say(get_token(message["flow"]), content)
      end
    elsif message["content"].match(/!rcon(\d+)/)
      if @@hlds_admins.include?(message["user"])
        server, command = message["content"].match(/^!rcon(\d.)(.*)$/i).captures
        ip, port, is_hltv, pwd = @@hlds_servers[server.to_i-1][0], @@hlds_servers[server.to_i-1][1], @@hlds_servers[server.to_i-1][2], @@hlds_servers[server.to_i-1][3]
        content = rcon_exec(ip, port, is_hltv, pwd, command)
        say(get_token(message["flow"]), content)
      elsif message["user"] == "0"
        # bot himself
      else
        say(get_token(message["flow"]), "Sorry, you're not a CS Admin.")
      end
    end
  end

  # Return number of players on server
  #
  # ==== Attributes
  #
  # * +ip+ - Counter-strike server ip
  # * +port+ - Counter-strike server port
  # * +is_hltv+ - Boolean, false for server, true for hltv (not supported currently)
  def get_status(ip, port, is_hltv, pwd)
    server = GoldSrcServer.new(IPAddr.new(ip), port, is_hltv)
    if is_hltv
      # nothing at this time...
    else
      begin
        server.rcon_auth(pwd)
        status    = server.rcon_exec('status')
        hostname, map, players = status.gsub(/\r?\n/, '').match(/^hostname: (.+)version.*map     :  (.+) at.+players : (.+)#  /).captures
        return "#{hostname} / #{map} / #{players}"
      rescue
        return 'Unknown command or authentication issue.'
      end
    end
  end

  # Exec a RCON command on the server
  #
  # ==== Attributes
  #
  # * +ip+ - Counter-strike server ip
  # * +port+ - Counter-strike server port
  # * +is_hltv+ - Boolean, false for server, true for hltv (not supported currently)
  # * +command+ RCON command to execute
  def rcon_exec(ip, port, is_hltv, pwd, command)
    server = GoldSrcServer.new(IPAddr.new(ip), port, is_hltv)
    if is_hltv
      # nothing at this time...
    else
      begin
        server.rcon_auth(pwd)
        status  = server.rcon_exec(command)
        hostname  = status.split(/\r?\n/)[0].gsub('hostname:  ', '')
        return "#{ip}:#{port} => #{hostname}"
      rescue
        return 'Unknown command or authentication issue.'
      end
    end
  end

end
