#
# Cookbook Name:: deployment
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

package 'unzip' do
end

docroot = node["deployment"]["DOCROOT"]


directory "#{node["deployment"]["DOCROOT"]}" do
  owner "#{node["deployment"]["USER"]}"
  group "#{node["deployment"]["USER"]}"
  mode '0755'
  action :create
end

bash "extracting_files" do
cwd "#{node["deployment"]["DOCROOT"]}"
code <<-EOH
unzip -o /tmp/Code.zip -d #{docroot}/
EOH
action :nothing
end

remote_file "/tmp/Code.zip" do
  source "#{node["deployment"]["JENKINSURL"]}/lastSuccessfulBuild/artifact/Code.zip"
  mode '0644'
notifies :run, "bash[extracting_files]", :immediately
end
