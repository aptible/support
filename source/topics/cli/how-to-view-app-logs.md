The best way to view your app logs is by configuring a log drain for your environment. In the Aptible dashboard, under your environment, select "Logging."
The log drain will aggregate the `stdout` and `stderr` streams from containers across your environment and send them to the endpoint of your choice.

Two popular options are to use [Papertrail](/topics/paas/how-to-set-up-papertrail/) for staging and test environments that do not handle PHI, or to [self-host an ELK stack](/topics/paas/how-to-set-up-your-own-logging-stack/) on Aptible for PHI-ready environments.
