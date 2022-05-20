#!/usr/bin/bash

#EDIT1:

cat >/etc/ssh/sshd_config<<EOF
Port 22
ListenAddress 0.0.0.0
PasswordAuthentication yes

Port 10831
Port 10832
Port 10833
Subsystem netconf "/usr/sbin/netconf-subsystem --ncxserver-sockname=10831@/tmp/ncxserver-10831.sock  --ncxserver-sockname=10832@/tmp/ncxserver-10832.sock --ncxserver-sockname=10833@/tmp/ncxserver-10833.sock"
EOF

#EDIT2:

cat >/etc/rc.local<<EOF
#!/bin/sh -e

ulimit -c unlimited
rm -f /tmp/ncxserver.sock
#--no-startup
export LD_LIBRARY_PATH=/usr/lib:/lib/aarch64-linux-gnu/
export HOME=/root
export PATH=.:$PATH

for port in 10831 10832 10833
do
    #mkdir /root/${port}
    #echo '<config/>' > /root/${port}/startup-cfg.xml
    cd /root/${port}
    rm -f /tmp/ncxserver-${port}.sock
    /usr/sbin/netconfd --startup=startup-cfg.xml --superuser=user --ncxserver-sockname=/tmp/ncxserver-${port}.sock --port=${port} --module=elsys-switch 1>netconfd.log 2>netconfd.stderr.log &
done

cd
cd diploma_project
python loop123.py

ulimit -c 0

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

exit 0
EOF

#EDIT3:
#Configure network fixed network with one static ip  before booting

cat >/etc/network/interfaces<<EOF
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source /etc/network/interfaces.d/*

#auto eth0
iface eth0 inet dhcp

auto eth0:1
allow-hotplug eth0:1
iface eth0:1 inet static
    address 192.168.209.35/24

EOF

#EDIT4:
#Add static ip instead of lightside-instruments.com to /etc/hostname

cat >/etc/hostname<<EOF
192.168.209.35  lightside-instruments.com
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters

127.0.1.1		raspberrypi
EOF

