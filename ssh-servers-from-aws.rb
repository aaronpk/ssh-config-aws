#!/usr/bin/env ruby
require 'aws-sdk'

Dir.chdir File.expand_path File.dirname(__FILE__)

slug = ARGV.join

config = File.read("aws/#{slug}.profile")

if !config
  puts "No config file found for #{slug}"
  exit
end

access_key_id = config.match(/AWS_ACCESS_KEY=(.+)/)[1]
secret_access_key = config.match(/AWS_SECRET_KEY=(.+)/)[1]

# Add more regions here if necessary. No harm in adding all of them, just makes the generation take longer to query more regions.
regions = [
  'us-east-1',
  'us-west-2'
]

ssh_config = ''

regions.each do |region|
  AWS.config access_key_id: access_key_id, secret_access_key: secret_access_key, region: region
  ec2 = AWS.ec2

  ec2.instances.each do |instance|
    if(instance.status == :running && instance.tags['Name'])
      instance_name = instance.tags['Name'].gsub /[^a-zA-Z0-9\-_\.]/, '-'
      instance_user = instance.tags['User'] || 'ubuntu'
      puts "#{instance.id}: #{instance_name} #{instance.ip_address} (#{instance_user})"
      ssh_config << "Host #{instance_name}\n"
      ssh_config << "  HostName #{instance.ip_address}\n"
      ssh_config << "  User #{instance_user}\n"
      ssh_config << "  IdentityFile ~/.ssh/#{instance.key_name}.aws.pem\n"
      ssh_config << "\n"
    end
  end
end

ssh_file = "ssh/#{slug}.sshconfig"
File.open(ssh_file, 'w') {|f| f.write(ssh_config) }

puts "Complete! Now run rebuild-ssh-config.sh to update your .ssh/config file"
