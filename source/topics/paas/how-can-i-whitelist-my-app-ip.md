Some partners or vendors you work with may use a whitelist, requiring you to provide them with your app's outbound IP address. This article contains information about what that IP is, how it might change, and how you can determine it. 

#### Background 

Your app is hosted in a private network (specifically, an AWS VPC) behind a single NAT gateway; all requests originating from your app will have that NAT's IP.  This is _different_ from the IPs associated with your app's endpoints (VHOSTs) used for _inbound_ requests.  

For a given NAT gateway we typically maintain a pool of at least 2 IPs, one associated with it and one left unassociated on reserve. 

Your outbound IP address will generally not change unless Aptible migrates your stack to a new VPC--something we would only do for major release versions of our backend system--or due to a failure of the underlying instance.  

In the case of a migration, the Aptible ops team will coordinate with you and provide you with new IPs for whitelisting before the migration is performed.  If required, we can also port your existing IP pool. 

In the case of an instance failure where we must replace the underlying instance, we will automatically failover to the unassociated IP. 

The IPs of your Aptible VHOSTs (what makes your app addressable) work differently.

VHOSTs use AWS Elastic Load Balancers (ELBs) to provide high-availability load balancing across availability zones. The IPs associated with an ELB are _not_ guaranteed to be static.

#### Determining your Aptible stack's outbound IP address

If you have `curl` installed in your Docker image and you want to retrieve this IP yourself, you can `aptible ssh` to your app and run `curl ipinfo.io`.  

You can also request the IP addresses from [support](contact.aptible.com). 
