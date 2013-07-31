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
