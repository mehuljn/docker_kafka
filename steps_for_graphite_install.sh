+++Steps for Installing Graphite++++++
apt-get upgrade
apt-get install graphite-web graphite-carbon

apt-get install postgresql libpq-dev python-psycopg2


sudo -u postgres psql
CREATE USER graphite WITH PASSWORD 'password';
CREATE DATABASE graphite WITH OWNER graphite;
\q

Changes for /etc/graphite/local_settings.py
SECRET_KEY
TIME_ZONE
USE_REMOTE_USER_AUTHENTICATION = True
DATABASES = {
    'default': {
        'NAME': 'graphite',
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'USER': 'graphite',
        'PASSWORD': 'password',
        'HOST': '127.0.0.1',
        'PORT': ''
    }
}

graphite-manage syncdb

Changes in /etc/default/graphite-carbon
 CARBON_CACHE_ENABLED=true

Changes in /etc/carbon/carbon.conf
 ENABLE_LOGROTATION = True

service carbon-cache start

apt-get install apache2 libapache2-mod-wsgi
a2dissite 000-default
cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available
a2ensite apache2-graphite
service apache2 reload
