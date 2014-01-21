require 'mycroft'

class Microphone < Mycroft::Client

  attr_accessor :verified

  def initialize(host, port)
    @key = ''
    @cert = ''
    @manifest = './app.json'
    @verified = false
    super
  end

  def connect
    # Your code here
  end

  def on_data(parsed)
    if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
      query('stt', 'request_stt', {})
      # we should send our grammer here

    elsif parsed[:type] == 'MSG_QUERY'
      client_ip = parsed[:data]['data']["ip"]
      client_port = parsed[:data]['data']["port"]

      # run vlc UDP using the client IP and Port
      `ffmpeg -ac 1 -f dshow -i audio="Microphone (Cirrus Logic CS4206B (AB 40))" -ar 16000 -acodec pcm_s16le -f rtp rtp://#{client_ip}:#{client_port}`
    elsif parsed[:type] == 'APP_DEPENDENCY'
      up
    end
  end

  def on_end
    # Your code here
  end
end

Mycroft.start(Microphone)
