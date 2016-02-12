Some partners or clients you work with may use a whitelist and require your app use a "static" IP.

The IP of requests _from_ your app will differ from the IP used for requests sent _to_ your app.

Your apps sit on a private network behind a single NAT instance. All requests originating from your app will have that NAT's IP--a dedicated AWS Elastic IP)

Your _origin_ IP will generally not change unless we migrate your stack to a new VPC--something we would only do for major release versions of our backend system.

If you have `curl` installed in your Docker image and you want to retrieve this IP yourself, you should be able to `aptible ssh` to your app and run `curl ipinfo.io`.  You can also request the IP from support. 

However, The IPs of your Aptible VHOSTs--what makes your app addressable--work a bit differently.

VHOSTs use AWS Elastic Load Balancers (ELBs) to provide high-availability load balancing across AZs. The IPs associated with an ELB are _not_ guaranteed to be static.
