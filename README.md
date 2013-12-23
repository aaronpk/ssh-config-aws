Auto-Generate SSH Config from AWS
=================================

Helper scripts to generate an `~/.ssh/config` file automatically from one or more AWS accounts.

Setup
-----

1. Create a file in the "aws" folder to store your AWS credentials, one file per AWS account
2. In your AWS account, ensure each server has a unique name, and add a "User" tag if the SSH username is different from "ubuntu"
3. Add your existing .ssh/config contents into a file in the "ssh" folder to save any settings or other servers you have there
4. Run `bundle install` to install the necessary gems
5. Source the `bash-complete.sh` file from your `.bash_profile` to enable autocomplete
6. Ensure you have the corresponding SSH private key in your `~/.ssh` folder that matches with the key listed on each EC2

Usage
-----

**Run `bundle exec ./ssh-servers-from-aws.rb example`**

Replace "example" with the name of your AWS profile. This will query your AWS account for all running servers, adding each to a file in the "ssh" folder.

**Run `rebuild-ssh-config.sh`**

This combines all your `.sshconfig` files into the master `~/.ssh/config` file.

Now you are ready to go! You can do things like:

`$ ssh e[TAB]` -> auto-expands to -> `$ ssh example`

Or if you have multiple servers with the same prefix,

```
$ ssh e[TAB][TAB]
example-1     example-2
```
