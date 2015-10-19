To add a custom domain (VHOST) to your Aptible app, you'll first need to locate the SSL certificate and private key for your domain. This may be a self-signed certificate, or it may be purchased from an SSL vendor. If you would like to re-use a previously uploaded cert, you may skip this step.

Once you've located the private key and certificate, find your app in the [Aptible Dashboard](https://dashboard.aptible.com), go to its Domains tab, and select "Add Domain." You can then either select "Add new certificate" and paste in your certificate and private key, or you may select one previously used from the drop-down menu.  The address will be automatically generated based on your certificate. Once you click "Save VHost", we will provision the new domain for you and display a VHOST address.

If you want to point to a subdomain of your app (e.g. "https://www.example.com/"), use the VHOST address to configure a new CNAME record with your DNS provider.

If you want to point to a "bare" or "apex" domain (e.g. "https://example.com/"), your approach will depend on which DNS provider you use. Some DNS providers provide "ALIAS" records, which allow you to point a bare domain at a hostname. Others only allow A records, which must be set to an IP address.

If you have questions about setting up this CNAME record with your DNS provider, please [contact support](https://support.aptible.com/contact).
