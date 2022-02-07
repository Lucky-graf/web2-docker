FROM ubuntu/apache2:latest

# install git
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y git

#


#start apache2
RUN service apache2 start
EXPOSE 80

#install PHP 7.4
RUN apt install software-properties-common -y &&\
    apt-get install ufw -y &&\
    add-apt-repository ppa:ondrej/php &&\
    apt update
RUN apt-get install -y php7.4 &&\
    apt-get install -y php7.4-mysql &&\
    apt-get install -y php-common &&\
    apt-get install -y php7.4-cli &&\
    apt-get install -y php7.4-json &&\
    apt-get install -y php7.4-common &&\
    apt-get install -y php7.4-opcache &&\
    apt-get install -y libapache2-mod-php7.4 &&\
    apt-get install -y php7.4-gd &&\
    apt-get install -y php7.4-ldap &&\
    apt-get install -y mysql-client
 
#take variable
ARG NAMESITE=web2 #"Input name your site"
ARG GITLINK='https://github.com/Lucky-graf/web2.git'#"Link on your site"
ARG DNSNAME=web2.cf   #Addres domen on your site (site.com)
ARG EMAIL=qwe@qwe.com #Add your email(email@posht.com)
ARG USERNAME=$USER    #Input name user
ARG VAR='${APACHE_LOG_DIR}'


#write config file
RUN echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/$DNSNAME.conf
RUN echo "ServerAdmin $EMAIL" >> /etc/apache2/sites-available/$DNSNAME.conf
RUN echo "ServerName $DNSNAME" >> /etc/apache2/sites-available/$DNSNAME.conf
RUN echo "ServerAlias www.$DNSNAME" >> /etc/apache2/sites-available/$DNSNAME.conf
RUN echo "DocumentRoot /var/www/$NAMESITE" >> /etc/apache2/sites-available/$DNSNAME.conf
RUN echo "ErrorLog $VAR/error.log" >> /etc/apache2/sites-available/$DNSNAME.conf
RUN echo "CustomLog $VAR/access.log combined" >> /etc/apache2/sites-available/$DNSNAME.conf
RUN echo "</VirtualHost>" >> /etc/apache2/sites-available/$DNSNAME.conf

#setting folder for site and clone
RUN git clone $GITLINK /var/www/web2/
RUN chmod -R 777 /var/www/web2
RUN mv /var/www/web2/files/config.php /var/www/web2/includes/config.php
RUN chmod -R 777 /var/www/web2/includes/config.php




#configure apach
RUN a2ensite $DNSNAME.conf
RUN a2dissite 000-default.conf

#restart apache service
RUN service apache2 restart

