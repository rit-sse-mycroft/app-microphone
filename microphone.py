import mycroft
import pyaudio

class Microphone(mycroft.App):

    def __init__(self):
        self.generate_instance_ids = True

    @mycroft.on('APP_DEPENDENCY')
    def on_app_dependency(self, event_name, body):
        self.up()

    @mycroft.on('MSG_QUERY')
    def on_msg_query(self, event_name, body):
        client_ip = body['data']['ip']
        port = body['data']['port']
        audio_client = socket.create_connection((client_ip, port))
        thread = threading.Thread(target=get_audio_in, args=[audio_client])
        thread.start()


    def get_audio_in(self, client):
        CHUNK = 1024
        FORMAT = pyaudio.paInt16
        CHANNELS = 2
        RATE = 44100

        p = pyaudio.PyAudio()

        stream = p.open(
            format=FORMAT,
            channels=CHANNELS,
            rate=RATE,
            input=True,
            frames_per_buffer=CHUNK
        )

        try:
            while True:
                try:
                    data = stream.read(CHUNK)
                    client.send(data)
                except ConnectionResetError:
                    break

        finally:
            stream.stop_stream()
            stream.close()

            p.terminate()


if __name__ == '__main__':
    app = Microphone()
    app.start(
        'app.json',
        'microphone'
    )
