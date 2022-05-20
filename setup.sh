
#0.Load the micro SD card image
#1.Enable ssh by creating empty ssh file in the boot partition



#2.Boot and connect to the static address with default user/pass pi/raspberry:

#ssh pi@192.168.209.35

#After booting configure wifi:

#sudo raspi-config

#3. Then follow this instructions
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

cd
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



cd
cd diploma_project
./setup-client.sh
./create-files.sh

#Reboot

reboot now
