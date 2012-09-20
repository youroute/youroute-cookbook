#
# Cookbook Name:: youroute
# Recipe:: server
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "youroute::default"

[
  'mongodb' # replace at mongodb recipe
].each do |name|
  package name do
    action :install
  end
end

rbenv_ruby "1.9.3-p125"
rbenv_global "1.9.3-p125"
rbenv_gem "bundler"

youroute_unicorn "avia" do
  root         "/srv/avia/current"
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "avia.youroute.ru", "prod.avia.youroute.ru" ]
end

logrotate_app "avia" do
  cookbook "logrotate"
  path "/srv/avia/current/logs/production.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end

logrotate_app "nginx" do
  cookbook "logrotate"
  path "/var/log/nginx/*.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end