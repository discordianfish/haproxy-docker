# haproxy + ucarp
This image runs a haproxy with ucarp to make it highly available.

This image uses host networking, which requires Docker >= 0.11.

## Configuration
To configure haproxy, you can either bind-mount a haproxy.cfg from your
host system to `/haproxy/haproxy.cfg` in the container or create a custom
image by using a Dockerfile like this:

    FROM fish/haproxy-docker
    ADD  haproxy.cfg /haproxy/haproxy.cfg

If you need graceful reloads and can't affort rebuilding and restarting
haproxy completely, you can bind-mount a config from your host and use
`docker kill -s HUP ...` to reload the config.

## Setup
Start a container like this on two hosts:

    $ docker run --cap-add=NET_ADMIN --net host fish/haproxy-docker 10.0.1.201 foobar23 wlan0

Now you should have two haproxy running and ucarp running on
the given interface, making sure only one listens on 10.0.1.201.

You can set the IPS env var to bind additional IPs on the active system.

## Caveats
If you're using IP based vhosts, you need to set
`net.ipv4.ip_nonlocal_bind=1` to allow the slave haproxy to bind to the
right addresses even if they are not configured on your interfaces.

## Failure Scenarios
If any service haproxy goes down, the container is supposed to kill
UCARP so the IP gets removed and the backup can take over.

If for any reasons this isn't working, kill the container manually.
This should cause the backup to take over.

If this is not the case, there is a problem with the backup container.
You might want to restart it.
