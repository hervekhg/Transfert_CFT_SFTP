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

