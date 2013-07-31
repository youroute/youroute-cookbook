#
# Cookbook Name:: youroute
# Recipe:: server
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'youroute::rubybased'

cookbook_file "/srv/youroute/current/htpasswd" do
  owner node['user']
  group node['user']
  mode "755"
end

runit_service "youroute-sidekiq" do
  options(
    :rails_root => "/srv/youroute/current",
    :rails_env => "staging"
  )
end

runit_service "youroute-sidekiq-image-processing" do
  options(
    :rails_root => "/srv/youroute/current",
    :rails_env => "staging"
  )
end

youroute_unicorn "youroute" do
  root         "/srv/youroute/current"
  rails_env    "staging"
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "dev.youroute.ru" ]
  password_protection true
end

runit_service "avia-faye" do
  options(
    :rails_root => "/srv/avia/current"
  )
end

youroute_unicorn "avia" do
  root         "/srv/avia/current"
  rails_env    "staging"
  serve_precompiled_assets true
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "dev.avia.youroute.ru" ]
  password_protection true
end