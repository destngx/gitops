# Using with AWS

You need to create an LoadBalancer in some where, and add the Ingress of Nginx to the group, so in case you might want to preserve the load balancer when deleting the ingress-nginx controller, the Nginx Ingress which is now a part of the Group, will not be deleted.

This is useful when you are migrating your cluster, and you want to preserve the LoadBalancer. So you will not need to update the Cloudfront origin, or the Route53 records.

