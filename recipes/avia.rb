#
# Cookbook Name:: youroute
# Recipe:: server
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node[:production] = true

include_recipe "youroute::rubybased"
include_recipe "elasticsearch::default"

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

{ "youroute" => "id_rsa", "youroute.pub" => "id_rsa.pub" }.each do |from, to|
  cookbook_file "/home/#{node['youroute']['deploy_user']}/.ssh/#{to}" do
    source from
    owner node['youroute']['deploy_user']
    group node['youroute']['deploy_user']
    mode "600"
  end
end

youroute_unicorn "avia" do
  root         "/srv/avia/current"
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "avia.youroute.ru", "prod.avia.youroute.ru" ]
end

runit_service "avia-faye" do
  options(
    :rails_root => "/srv/avia/current"
  )
end

logrotate_app "nginx" do
  cookbook "logrotate"
  path "/var/log/nginx/*.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end