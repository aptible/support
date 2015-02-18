If you receive this error, it usually means one of two things:

* Your app server failed to start because of an error. If this is the case, you can run `aptible logs` while deploying (or examine your app's logs stored in a third-party log drain) to find more information about the error.
* Your app server started, but is running in the background (i.e., as a "daemon"). Any Aptible app service must run in the foreground, otherwise its Docker container will terminate. If this is the case, check the command in your Procfile and make sure it's launching your process in the foreground.
