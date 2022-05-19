
#0.Load the micro SD card image
#1.Enable ssh by creating empty ssh file in the boot partition
#2.Configure network fixed network with one static ip  before booting
cat /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source /etc/network/interfaces.d/*

#auto eth0
iface eth0 inet dhcp

auto eth0:1
allow-hotplug eth0:1
iface eth0:1 inet static
    address 192.168.209.35/24


#3.Boot and connect to the static address with default user/pass pi/raspberry:

ssh pi@192.168.209.35

#After booting configure wifi:

sudo raspi-config

#4. Then follow this instructions
#They will start 3 elsys-switch servers on port 10831, 10832, 10833 and will be available after reboot 

sudo su

apt-get update
apt-get upgrade


# apt-get install -y netconfd libyuma-dev

cd
apt-get install -y git autoconf gcc libtool libxml2-dev libssh2-1-dev make libncurses5-dev zlib1g-dev libreadline-dev libssl-dev
git clone https://github.com/vlvassilev/yuma123.git
cd yuma123
autoreconf -i -f
./configure CFLAGS="-g -O0"  CXXFLAGS="-g -O0" --prefix=/usr
make
make install

git clone https://github.com/dip2022/diploma_project.git
cd diploma_project
autoreconf -i -f
./configure CFLAGS="-g -O0"  CXXFLAGS="-g -O0" --prefix=/usr
make
make install


mkdir /root/10831
echo "<config/>" > /root/10831/startup-cfg.xml
mkdir /root/10832
echo "<config/>" > /root/10832/startup-cfg.xml
mkdir /root/10833
echo "<config/>" > /root/10833/startup-cfg.xml

 
adduser user # pass:ietf113




cat /usr/bin/elsys-switch-set | sed s/23/27/ | tee /root/10832/elsys-switch-set
chmod ugo+x /root/10832/elsys-switch-set

cat /usr/bin/elsys-switch-set | sed s/23/17/ | tee /root/10833/elsys-switch-set
chmod ugo+x /root/10833/elsys-switch-set






#EDIT1:

cat /etc/ssh/sshd_config
...
Port 10831
Port 10832
Port 10833
Subsystem netconf "/usr/sbin/netconf-subsystem --ncxserver-sockname=10831@/tmp/ncxserver-10831.sock  --ncxserver-sockname=10832@/tmp/ncxserver-10832.sock --ncxserver-sockname=10833@/tmp/ncxserver-10833.sock"


#EDIT2:

cat /etc/rc.local
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

ulimit -c 0
# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

exit 0



#Reboot

reboot now

