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

[
  'openjdk-7-jre' # required by ElasticSearch
].each do |name|
  package name do
    action :install
  end
end

rbenv_ruby node['ruby']['version']
rbenv_global node['ruby']['version']
rbenv_gem "bundler"

{ "youroute" => "id_rsa", "youroute.pub" => "id_rsa.pub" }.each do |from, to|
  cookbook_file "/home/#{node['youroute']['deploy_user']}/.ssh/#{to}" do
    source from
    owner node['youroute']['deploy_user']
    group node['youroute']['deploy_user']
    mode "600"
  end
end

logrotate_app "nginx" do
  cookbook "logrotate"
  path "/var/log/nginx/*.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end

template "/etc/nginx/sites-enabled/hotels.conf" do
  source "nginx-maintenance.conf.erb"
  mode "644"
  owner "root"
  group "root"
  variables(
    :root => "/srv/hotels/current",
    :server_names => ['hotels.youroute.ru']
  )
end

runit_service "youroute-sidekiq" do
  options(
    :rails_root => "/srv/youroute/current",
    :rails_env => "production"
  )
end

runit_service "youroute-sidekiq-image-processing" do
  options(
    :rails_root => "/srv/youroute/current",
    :rails_env => "production"
  )
end

youroute_unicorn "youroute" do
  root         "/srv/youroute/current"
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "prod.youroute.ru", "youroute.ru" ]
  redirect_subdomains_at "youroute.ru"
end
