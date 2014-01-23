require 'mycroft'

class Microphone < Mycroft::Client

  attr_accessor :verified

  def initialize(host, port)
    @key = ''
    @cert = ''
    @manifest = './app.json'
    @generate_instance_ids = true
    @verified = false
    super
  end

  def connect
    # Your code here
  end

  def on_data(parsed)
    if parsed[:type] == 'MSG_QUERY'
      client_ip = parsed[:data]['data']["ip"]
      client_port = parsed[:data]['data']["port"]

      # run vlc UDP using the client IP and Port
      `ffmpeg -ac 1 -f dshow -i audio="YOUR MICROPHONE" -ar 16000 -acodec pcm_s16le -f rtp rtp://#{client_ip}:#{client_port}`
    elsif parsed[:type] == 'APP_DEPENDENCY'
      up
    end
  end

  def on_end
    # Your code here
  end
end

Mycroft.start(Microphone)
