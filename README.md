[![Build Status](https://img.shields.io/travis/ryandoyle/vagrancy.svg)](https://travis-ci.org/ryandoyle/vagrancy)

> Private Vagrant box hosting

Vagrancy implments a self-hosted subset of [Atlas](https://atlas.hashicorp.com/), (formally [Vagrant Cloud](https://vagrantcloud.com)). It allows you to build images in Packer, pushlish them and then share the images with your co-workers via Vagrant, all on-premise.

### Install
Vagrancy has all its dependencies packaged with it. It requires no runtime at all.
```shell
wget https://github.com/ryandoyle/vagrancy/releases/download/0.0.4/vagrancy-0.0.4-linux-x86_64.tar.gz
tar xvf vagrancy-0.0.4-linux-x86_64.tar.gz
cd vagrancy-0.0.4-linux-x86_64
./vagrancy
```

### Upgrade
If you configured `filestore_path` in `config.yml` to a directory outside of the Vagrancy install, there's not much to do. Copy this file over from the old install and you're good to go:
```shell
wget https://github.com/ryandoyle/vagrancy/releases/download/0.0.4/vagrancy-0.0.4-linux-x86_64.tar.gz
tar xvf vagrancy-0.0.4-linux-x86_64.tar.gz
cp vagrancy-3-linux-x86_64/config.yml vagrancy-0.0.4-linux-x86_64/
cd vagrancy-0.0.4-linux-x86_64/
# Stop old instance of Vagrancy running before running the new one below
./vagrancy
```
If you did not rename `config.sample.yml` to `config.yml` and configure this file, Vagrancy would have stored your boxes in a `data/` directory in the root of the untar-ed application. Move or copy this folder to the new install.


### Publishing images
##### Via Packer
Add something like the following to your `.json` Packer file. For Packer versions <= 0.8.2, use `server_address`, *not* `atlas_url`.
```
  ...
  "post-processors": [                              
    {   
      "output": "box/{{.Provider}}/ubuntu1404-{{user `cm`}}{{user `cm_version`}}-{{user `version`}}.box",
      "type": "vagrant"
    },  
    {   
      "type": "atlas",
      "artifact": "myusername/ubuntu",
      "artifact_type": "vagrant.box",
      "atlas_url": "http://localhost:8099/",
      "metadata": {
        "provider": "virtualbox",
        "version": "1.0.0"
      }   
    }   
  ], 
  ...
```
##### Manually uploading
You can easily upload a box you have built locally using `curl`.
```
curl http://localhost:8099/myusername/ubuntu/1.0.0/virtualbox --upload-file ubuntu-precise.box
```

### Using in Vagrant
Using Vagrancy requires a different Vagrant server URL. This can be set as an environment variable *or* as part of the `Vagrantfile`. Here is an example `Vagrantfile` with the server URL set.
```ruby
ENV['VAGRANT_SERVER_URL'] = 'http://localhost:8099'
Vagrant.configure(2) do |config|
  config.vm.box = "myusername/ubuntu"
end
```
### API
Operation| Command 
---------|----------
**Deleting a box** | `curl -XDELETE http://localhost:8099/myusername/ubuntu/1.0.0/virtualbox`
**Manually uploading a box** | `curl http://localhost:8099/myusername/ubuntu/1.0.0/virtualbox --upload-file ubuntu-precise.box`
**Listing box versions** | `curl http://localhost:8099/myusername/ubuntu`
**Deleting all box versions** | *Each box must be specifically deleted*

### Security
Vagrancy is intending to be used in a trusted network and hence doesn't deal with authentication. As can be see in
the above examples, reading, writing and modifying boxes is allowed without authentication.