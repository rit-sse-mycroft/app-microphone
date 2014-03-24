import mycroft
import pyaudio
import socket
import threading

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
        audio_client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        thread = threading.Thread(target=self.get_audio_in, args=[audio_client, client_ip, port])
        thread.start()

    @mycroft.on('error')
    def on_error(self, event_name, e):
        print(e)

    def get_audio_in(self, client, ip, port):
        CHUNK = 1024
        FORMAT = pyaudio.paInt16
        CHANNELS = 1
        RATE = 16000

        p = pyaudio.PyAudio()

        stream = p.open(
            format=FORMAT,
            channels=CHANNELS,
            rate=RATE,
            input=True,
            frames_per_buffer=CHUNK
        )

        try:
            self.logger.info('Sending Audio')
            while True:
                try:
                    data = stream.read(CHUNK)
                    client.sendto(data, (ip, port))
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
