Aptible uses [NGiNX proxies](https://github.com/aptible/docker-nginx) to
terminate SSL for all requests. We offer a few ways to configure the way your
app handles SSL by forwarding certain environment variables from your Aptible
app configuration to the NGiNX proxies:

* `FORCE_SSL`: By default, an Aptible app responds to both HTTP and HTTPS. Your
  app can detect which protocol is being used by examining a request's
  X-Forwarded-Proto header, which is set to "https" if HTTPS was used and unset
  otherwise. If you wish to disallow HTTP entirely, you can set the
  `FORCE_SSL` environment variable in your app's configuration. This will
  redirect all HTTP traffic to HTTPS and set the
  [Strict-Transport-Security](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security)
  header on responses with a max age of 1 year. Make sure you understand the
  implications of setting the Strict-Transport-Security header before turning
  this feature on. In particular, by design, clients that connect to your site
  and receive this header will refuse to reconnect via HTTP for up to a year
  after they receive the Strict-Transport-Security header.

* `DISABLE_WEAK_CIPHER_SUITES`: Aptible's supported SSL protocols and cipher
  suites balance security and support for older clients. If you wish to target
  only modern clients, you can set the `DISABLE_WEAK_CIPHER_SUITES`
  environment variable to disable the SSLv3 protocol and the RC4 cipher, both
  of which are otherwise allowed in the default configuration.

Either or both of these configuration options can be enabled by setting the
environment variables to `true` on the corresponding Aptible app using the
[Aptible CLI](/topics/cli/how-to-install-cli):

```
aptible config:set FORCE_SSL=true --app $APP_HANDLE
aptible config:set DISABLE_WEAK_CIPHER_SUITES=true --app $APP_HANDLE
```

After setting either option, you must restart the app to pick up the
configuration changes:

```
aptible restart --app $APP_HANDLE
```