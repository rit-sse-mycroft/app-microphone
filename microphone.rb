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

  on 'MSG_QUERY' do |data|
    client_ip = data['data']["ip"]
    client_port = data['data']["port"]

    # run vlc UDP using the client IP and Port
    `ffmpeg -ac 1 -f dshow -i audio="YOUR MICROPHONE" -ar 16000 -acodec pcm_s16le -f rtp rtp://#{client_ip}:#{client_port}`
  end

  on 'APP_DEPENDENCY' do |data|
    up
  end

end

Mycroft.start(Microphone)
