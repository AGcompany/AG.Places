apt-get update
apt-get install -y -q \
                      python-libxml2\
                      python-lxml\
                      python-imaging\
                      python-ldap\
                      python-simplejson\
                      python-crypto\
                      python-setuptools\
                      xpdf\
                      wv\
                      build-essential\
                      python-dev\
                      libpcre3\
                      libpcre3-dbg\
                      libpcre3-dev\
                      libssl-dev\
                      openssl\
                      pkg-config


apt-get install binutils
apt-get install libgeos-c1


# Install dependencies
easy_install zc.buildout==1.4.4

# FIXED 
# An error occured when trying to install lxml 2.3.4. Look above this message for any errors that were output by easy_install.
# While:
#   Installing instance.
#   Getting distribution for 'lxml==2.3.4'.
# Error: Couldn't install: lxml 2.3.4
# *************** PICKED VERSIONS ****************

apt-get install -y -q libxml2
apt-get install -y -q python-libxslt1
apt-get install -y -q libxslt-dev
easy_install lxml



apt-get install nginx

locale-gen ru_RU.UTF-8
locale-gen en_US.UTF-8

#    1  sudo ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so /usr/lib/
#    2  sudo ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib/
#    3  sudo ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/
#    4  sudo ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so.6 /usr/lib/
#    5  sudo ln -s /usr/lib/x86_64-linux-gnu/libz.so /lib/

