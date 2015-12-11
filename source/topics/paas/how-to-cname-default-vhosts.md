This error indicates that the CNAME requested does not match the associated host. This often happens when one has associated a new domain (e.g. myapp-staging.com) to a default vhost ($APP-ID.on-aptible.com). Aptible has its own wildcard certificate which covers all default vhosts.  This causes a browser to throw an error when the requested domain does not match.

Instead, provision a separate custom vhost for the app in question, and map this to your desired hostname using your DNS provider of choice.
