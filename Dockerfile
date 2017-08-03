FROM resin/rpi-raspbian

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

# build libcec
WORKDIR /tmp
RUN git clone https://github.com/Pulse-Eight/platform.git && \
    mkdir platform/build && \
    cd platform/build && \
    git checkout a822e196cb57d8545dccca6cc22fda0f83c34321 && \
    cmake .. && \
    make && \
    make install && \
    cd - && \
    git clone https://github.com/Pulse-Eight/libcec.git && \
    mkdir libcec/build && \
    cd libcec/build && \
    git checkout f2c4ca7702d5ae0301c9648fee7cf5525b4e11db && \
    cmake -DRPI_INCLUDE_DIR=/opt/vc/include -DRPI_LIB_DIR=/opt/vc/lib .. && \
    make -j4 && \
    make install && \
    ldconfig && \
    rm -rf /tmp/*

# Default home assistant configuration
VOLUME /config

# install home assistant, mysql client
RUN pip3 install mysqlclient
RUN pip3 install git+git://github.com/sterling/home-assistant#v0.49.1

CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
