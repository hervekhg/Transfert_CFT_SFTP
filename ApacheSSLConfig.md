# Exemple configuration SSL apache
* **Step 1**: Use OpenSSL to produce the keys that are used to secure your site. 
These keys are used when encrypting and decrypting the traffic to your secure site.
This command will create a 1024 bit private key and puts it in the file mydomain.key.
<pre> openssl genrsa -out mydomain.key 1024 </pre>

* **Step 2**: Generate your own certificate .
<pre> openssl req -new -key mydomain.key -x509 -out mydomain.crt </pre>

* **Step 3**: Keep the pricate key in the directory **/etc/apache2/ssl.key/** and certificate in the directory **/etc/apache2/ssl.crt/**.
Note: The ssl.key directory must be only readable by root.

* **Step 4**: Now you need to edit httpd.conf file in /etc/apache2
<pre>
Alias /mediawiki "/opt/mediawiki"
"<"VirtualHost *:443">"
        ServerAdmin hk@site.fr
        ServerName mediawiki.test.fr
        ServerAlias mediawiki
        DocumentRoot /opt/mediawiki
        <Directory "/opt/mediawiki">
                Options Indexes MultiViews
                AllowOverride None
                Order allow,deny
                Allow from all
        </Directory\>
        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/mydomain.crt
        SSLCertificateKeyFile /etc/ssl/private/mydomain.key
"<"/VirtualHost">"
</pre>

* **Step 5**: You can get to the default site using SSL just by browsing to https://localhost (you don't need to add the port to the end of the URL). If you want to forward all HTTP requests to HTTPS (which is what I believe you are trying to achieve), you can either add a permanent redirect, or use the Apache module mod_rewrite. **The easiest and most secure way is to set up a permanent redirect**. Enable named virtual hosts and add a Redirect directive to the VirtualHost in /etc/httpd/conf/httpd.conf.

<pre>
NameVirtualHost *:80
"<"VirtualHost *:80">"
   ServerName localhost
   Redirect permanent / https://localhost
"<"/VirtualHost">"
</pre>

* **Step 5**: If you want to turn SSL off, comment out these lines in /etc/httpd/conf.d/ssl.conf and restart Apache.
<pre>
LoadModule ssl_module modules/mod_ssl.so
Listen 443
</pre>

