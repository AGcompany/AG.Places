
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
                      python-dev


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
