
# steps

* aws: ACM Cert create *.${your_root_domain} / need DNS add CNAME
* aws: create lambda function and copy mine demo
* aws: api gateway add resource /{proxy+}, stage:default, and customized domain
* browser: https://${you_api_entry}/DebugRaw
