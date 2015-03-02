To add a custom external domain (VHOST) to your Aptible app, you'll first need to locate the SSL certificate and private key for your domain. This may be a self-signed certificate, or it may be purchased from an SSL vendor.

Once you've located the private key and certificate, visit the [Aptible Dashboard](https://dashboard.aptible.com), navigate to your app, and click "Add a VHOST" next to the service which you'd like to expose with your custom domain.

Then, enter the address of your custom domain (e.g. "myapp.example.com"), and paste in your certificate and private key. Once you click "Add Virtual Host", we will provision the new domain for you, and display a VHOST address, which you can use to configure a new CNAME record with your DNS provider.

If you have questions about setting up this CNAME record with your DNS provider, please [contact support](https://support.aptible.com/contact).