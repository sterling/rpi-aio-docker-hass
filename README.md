# rpi-aio-docker-hass
All-in-one docker image for Home Assistant on a Raspberry Pi. Tested on a Raspberry Pi 3 with Raspian 8 (jessie). Uses a [fork of Home Assistant](https://github.com/sterling/home-assistant).

Supports (and not limited to):
- v0.58+
  - zwave
  - hdmi cec
  - nmap scanner
  - ssh device tracker
  - curl
  - mysql recorder (requires [separate mysql server](#mysql))

## Example Usage

```bash
# home assistant
docker run -d --name=home-assistant --net=host --rm \
  --device=/dev/vchiq:/dev/vchiq --device=/dev/zwave:/dev/zwave \
  -v ~/hass-config:/config -v /etc/localtime:/etc/localtime:ro -v ~/.ssh:/ssh \
  sterlingw/rpi-aio-home-assistant:v0.58
```
#### Parameters Explained
- `--net=host` Optional, depending on your use case. You may expose specific ports or just use this for simplicity. This works well for things like Amazon Alexa/Emulated Hue.
- `--rm` Optional. Removes the container when it is stopped. For more stability, use `--restart=always`.
- `--device=/dev/vchiq:/dev/vchiq` Required to enable HDMI CEC components.
- `--device=/dev/zwave:/dev/zwave` Required to enable zwave devices. Use the device mapped to your zwave hub controller. Eg: `/dev/ttyACM0` or `/dev/ttyACM1` etc.
- `-v ~/hass-config:/config` Specifies the Home Assistant config directory.
- `-v /etc/localtime:/etc/localtime:ro` Sets the container's timezone to the host's timezone.
- `-v ~/.ssh:/ssh` Used to gain access to host's ssh keys for ssh-based components.

### Other Containers

#### MySQL

```bash
# mysql
docker run -d --name=mysql -p 3306:3306 --rm \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_DATABASE=homeassistant -e MYSQL_USER=hass -e MYSQL_PASSWORD=hass \
  -v ~/hass-config/db:/var/lib/mysql \
  hypriot/rpi-mysql
```
You may use another container to host the `recorder` component database (like MySQL, for example). With the above example, connections can be made at `mysql://hass:hass@127.0.0.1/homeassistant`. Don't use `localhost` because MySQL will try to connect via a unix socket instead of a TCP connection. 

#### Nginx
```bash
# nginx
docker run --name nginx -v ~/hass-config/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -v ~/hass-config/ssl/:/etc/nginx/ssl/ -d -p 8123:443 arm32v7/nginx
```
