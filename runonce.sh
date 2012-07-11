
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
