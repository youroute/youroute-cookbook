#
# Cookbook Name:: dev_main
# Recipe:: development
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "dev_main::default"

# gem_package "mysql"
# mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
# %w{development test production}.each do |database|
#   mysql_database "#{database}" do
#     connection mysql_connection_info
#     encoding "utf8"
#     action :create
#   end
# end

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