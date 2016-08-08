# cookbook-downloadbox

Chef Cookbook for deploying NZBGet, Sonarr and CouchPotato onto a CentOS Server utilising Docker Containers.

## Supported Platforms

* CentOS 7.x

## Usage

Deployment on a CentOS Server can be automated by calling the following script:

```
bash <(curl https://raw.githubusercontent.com/cpressland/cookbook-downloadbox/master/install.sh)
```

## Known issues

* Chef will automatically overwrite the NZBGet config on each run.

## Todo

* Update documentation
* Automatically configure NZBGet, Sonarr and CouchPotato

## License and Authors

Author:: Chris Pressland (mail@cpressland.io)
