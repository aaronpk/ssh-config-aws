#!/usr/bin/env ruby
# Read AWS credential.csv format files and write export shell statements
# into corresponding aws/*.profile files
#
# Usage: transform-csv-to-sh.rb ~/Downloads/*csv

require 'csv'

credential_csv = ARGV

credential_csv.each do |cred_file|
  aws_config = ''
  CSV.foreach(cred_file, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
    if row.headers.join != "user_nameaccess_key_idsecret_access_key"
      puts "Skipping #{cred_file}, missing expected headers."
      next
    end
    profile_file = "aws/#{File.basename(cred_file)}.profile"
    File.open(profile_file, 'w') do |f|
      f.puts "# AWS #{row.headers[0]} #{row.fields[0]}"
      f.puts "export AWS_ACCESS_KEY=#{row.fields[1]}"
      f.puts "export AWS_SECRET_KEY=#{row.fields[2]}"
    end
    puts "Transformed #{cred_file} into #{profile_file}"
  end
end
