require 'mycroft'

class Microphone < Mycroft::Client

  attr_accessor :verified

  def initialize
    @key = '/path/to/key'
    @cert = '/path/to/cert'
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
      # we should send our grammer here
      
    elsif parsed[:type] == 'MSG_QUERY' and parsed[:action] == "stream request"
      clientIp = parsed[:data]["ip"]
      clientPort = parsed[:data]["port"]

      # run vlc UDP using the client IP and Port
      `vlc dshow:// --sout=#transcode{vcodec=none,acodec=mp3,ab=128,channels=2,samplerate=44100}:udp{dst=#{clientIp}:#{clientPort}}`
    end

  end

  def on_end
    # Your code here
  end
end

Mycroft.start(Microphone)
