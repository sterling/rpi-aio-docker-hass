FROM homeassistant/raspberrypi3-homeassistant

RUN apk --no-cache add git

RUN pip3 install git+git://github.com/sterling/home-assistant#v0.58

CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
