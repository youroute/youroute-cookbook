#
# Cookbook Name:: youroute
# Recipe:: server
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "youroute::default"

rbenv_ruby "1.9.3-p125"
rbenv_global "1.9.3-p125"
rbenv_gem "bundler"

cookbook_file "/srv/youroute/current/htpasswd" do
  owner node['user']
  group node['user']
  mode "700"
end

youroute_unicorn "youroute" do
  root         "/srv/youroute/current"
  runit_user   "ubuntu"
  runit_group  "ubuntu"
  server_names [ "dev.youroute.ru" ]
  password_protection true
end

# require_recipe "gitlabhq"

# youroute_unicorn "gitlabhq" do
#   root         "/home/gitlabhq/gitlabhq/current"
#   runit_user   "gitlabhq"
#   runit_group  "gitlabhq"
# end