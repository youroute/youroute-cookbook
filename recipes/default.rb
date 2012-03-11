#
# Cookbook Name:: dev_main
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "console-cyrillic"
require_recipe "apt"
require_recipe "locale-gen"
require_recipe "locale"
require_recipe "git"
require_recipe "zsh"
require_recipe "oh-my-zsh"
require_recipe "ruby_build"
require_recipe "rbenv"
require_recipe "database"
require_recipe "mysql"
require_recipe "mysql::server"
require_recipe "postgresql::server"

gem_package "mysql"

[
  ### this packages is nessesary for build nokogiri native extensions
  'libxml2-dev',
  'libxslt1-dev',
  ###
  'libsqlite3-dev', # this is for bundle install after rails new
  'build-essential', # this is for therubyracer gem
  'autoconf', # for ruby-1.9.3-perf
  'bison' # for ruby-1.9.3-p125-perf
].each do |name|
  package name do
    action :install
  end
end

mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
%w{development test production}.each do |database|
  mysql_database "#{database}" do
    connection mysql_connection_info
    encoding "utf8"
    action :create
  end
end

# rbenv_ruby "1.9.3-p0"

bash "install ruby-1.9.3-p125-perf" do
  # code below executes "curl https://raw.github.com/gist/1688857/rbenv.sh | sh"
  code <<-EOH
    VERSION="1.9.3-p125"
    curl https://raw.github.com/gist/1688857/2-$VERSION-patched.sh > /tmp/$VERSION-perf
    rbenv install /tmp/$VERSION-perf
  EOH
  user 'rbenv'
  not_if { ruby_version_installed?('1.9.3-p125-perf') }
end

rbenv_global "1.9.3-p125-perf"
rbenv_gem "bundler"