# Microphone

##How To Use Microphone App

### Prerequisites
* Ruby 1.9.3 or greater
* The mycroft gem
* [ffmpeg](http://www.ffmpeg.org/download.html) must be on your path

### Usage
#### Windows
1. Open up cmd prompt and run this command
`ffmpeg -list_devices true -f dshow -i dummy`
Look for your microphone in that output.  You will see that it has a name.
2. Open up `microphone.rb`
3. Replace the phrase YOUR MICROPHONE with the name of your microphone
4. You now should be able to use microphone app.

#### Linux
1. Open up `microphone.rb`
2. Replace `dshow -i audio="YOUR MICROPHONE"` with `alsa -i audio=hw:1,0`
3. You should now be able to use the microphone app

#### Mac
1. Boot into Windows
2. Follow the windows usage
