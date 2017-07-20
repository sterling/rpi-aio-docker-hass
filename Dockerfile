FROM resin/rpi-raspbian:jessie

RUN apt-get update && \
    apt-get install --no-install-recommends \

      # home assistant installation
      build-essential python3-dev python3-pip \

      # notify.html5
      libffi-dev libpython-dev libssl-dev \

      # zwave
      libudev-dev \
      
      # nmap scanner
      net-tools nmap \

      # device tracker
      ssh \

      # wake on lan
      iputils-ping \

      # hdmi cec
      cmake libudev-dev libxrandr-dev python-dev swig libraspberrypi-dev \

      # mysql client
      libmysqlclient-dev \

      # network components
      curl \ 

      # package installation
      git && \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install home assistant, mysql client
RUN pip3 install \
      git+git://github.com/sterling/home-assistant#v0.48.1 \
      mysqlclient

# build libcec
WORKDIR /tmp
RUN git clone https://github.com/Pulse-Eight/platform.git && \
    mkdir platform/build && \
    cd platform/build && \
    cmake .. && \
    make && \
    sudo make install && \
    cd - && \
    git clone https://github.com/Pulse-Eight/libcec.git && \
    mkdir libcec/build && \
    cd libcec/build && \
    cmake -DRPI_INCLUDE_DIR=/opt/vc/include -DRPI_LIB_DIR=/opt/vc/lib .. && \
    make -j4 && \
    sudo make install && \
    sudo ldconfig && \
    rm -rf /tmp/*

# Default home assistant configuration
VOLUME /config

 
CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
