FROM homeassistant/raspberrypi3-homeassistant

RUN apk --no-cache add git

RUN pip3 uninstall homeassistant -y \
    && pip3 install git+git://github.com/sterling/home-assistant#v0.61.1

CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
