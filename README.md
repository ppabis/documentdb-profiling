Profiling example on AWS DocumentDB
===================================
Refer to this blog post for more details:

https://pabis.eu/blog/2023-10-31-AWS-DocumentDB-Profiling.html

To run, apply it to your cluster with Terraform/OpenTofu. Use the following
command to get the connection URL:

```shell
$ terraform output mongo_url
### In the test instance via SSM or SSH
$ export MONGO_URL=<output of the above>
```