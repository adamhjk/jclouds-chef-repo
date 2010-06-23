#
# Cookbook Name:: tomcat6
# Recipe:: default
#
# limitations under the License.
#

# This is for the DSCL provider, totally!
require 'pp'

group node[:tomcat6][:user] do
end

user node[:tomcat6][:user] do
  comment "Apache Tomcat"
  gid node[:tomcat6][:user]
  home node[:tomcat6][:home]
  shell "/bin/sh"
end

[node[:tomcat6][:home],node[:tomcat6][:logs],node[:tomcat6][:package]].each do |dir|
  directory dir do
    mode 0755
    owner "#{node[:tomcat6][:user]}"
    group "#{node[:tomcat6][:user]}"
  end
end

tomcat_version_name = "apache-tomcat-#{node[:tomcat6][:version]}"
tomcat_version_name_tgz = "#{tomcat_version_name}.tar.gz"
tomcat_download_file = "/tmp/#{tomcat_version_name_tgz}"
tomcat_download_directory = "/tmp/#{tomcat_version_name}"

tomcat_url = "http://archive.apache.org/dist/tomcat/tomcat-6/v#{node[:tomcat6][:version]}/bin/#{tomcat_version_name_tgz}"

remote_file tomcat_download_file do
  source tomcat_url
  checksum "9a2e99ab2141a6f02280831d5cf18594e61bee348b6a295cd2aa1b3ef9f9aa67"
end

execute "uncompress tomcat" do
  command "tar zxvf #{tomcat_download_file}"
  cwd "/tmp"
  action :nothing
  subscribes :run, resources(:remote_file => tomcat_download_file), :immediately
end

execute "move in place" do
  command "cp -r #{tomcat_download_directory}/* #{node[:tomcat6][:home]}"
  cwd "/tmp"
  action :nothing
  subscribes :run, resources(:execute => "uncompress tomcat"), :immediately
end

directory "#{node[:tomcat6][:home]}" do
  owner "#{node[:tomcat6][:user]}"
  group "#{node[:tomcat6][:user]}"
  recursive true
end

directory "#{node[:tomcat6][:home]}/bin" do
  mode 0755
end

cookbook_file "#{node[:tomcat6][:conf]}/logging.properties" do
  source "logging.properties"
  mode 0644
  owner "#{node[:tomcat6][:user]}"
  group "#{node[:tomcat6][:user]}"
end

template "#{node[:tomcat6][:conf]}/tomcat-users.xml" do
  source "tomcat-users.xml.erb"
  mode 0644
  owner "#{node[:tomcat6][:user]}"
  group "#{node[:tomcat6][:user]}"
end

template "#{node[:tomcat6][:webapps]}/host-manager/manager.xml" do
  source "manager.xml.erb"
  mode 0644
  owner "#{node[:tomcat6][:user]}"
  group "#{node[:tomcat6][:user]}"
end

cookbook_file "/Library/LaunchDaemons/org.apache.tomcat.tomcat6.plist" do
  source "org.apache.tomcat.tomcat6.plist"
  mode 0644
  owner "root"
end

execute "launchctl load /Library/LaunchDaemons/org.apache.tomcat.tomcat6.plist" do
  action :nothing
  subscribes :run, resources(:cookbook_file => "/Library/LaunchDaemons/org.apache.tomcat.tomcat6.plist"), :immediately
end

