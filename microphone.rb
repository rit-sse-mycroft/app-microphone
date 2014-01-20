require 'mycroft'

class Microphone < Mycroft::Client

  attr_accessor :verified

  def initialize
    @key = ''
    @cert = ''
    @manifest = './app.json'
    @verified = false
  end

  def connect
    # Your code here
  end

  def on_data(data)
    puts data
    parsed = parse_message(data)
    if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
      check_manifest(parsed)
      @verified = true
      query('stt', 'request_stt', {})
      # we should send our grammer here
      
    elsif parsed[:type] == 'MSG_QUERY_SUCCESS'
      client_ip = parsed[:data]['ret']["ip"]
      client_port = parsed[:data]['ret']["port"]

      # run vlc UDP using the client IP and Port
      `ffmpeg -ac 1 -f dshow -i audio="Microphone (Cirrus Logic CS4206B (AB 40))" -ar 16000 -acodec pcm_s16le -f rtp rtp://#{client_ip}:#{client_port}`
    end

  end

  def on_end
    # Your code here
  end
end

Mycroft.start(Microphone)
