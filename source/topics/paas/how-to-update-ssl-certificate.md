Aptible recommends a few best practices for SSL renewal. Using your chosen DNS provider,

- Ensure that you have current `WHOIS` information for your domain
- Apply 30 days in advance your certificate's expiration
- Generate a new CSR code with a private key of no less than 2048 bits

Once you have renewed your certificate, you'll need to update your vhosts in Aptible by adding the renewed cert.

Log into dashboard, and navigate to your apps' domains tab. Click _Edit_, then _Add new certificate_

_NB: Be sure your certificate bundle is [correctly ordered](https://support.aptible.com/topics/paas/how-to-order-certs/)_
