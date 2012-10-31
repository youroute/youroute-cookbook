#
# Cookbook Name:: youroute
# Recipe:: server
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node[:production] = true

include_recipe "youroute::default"

[
  'openjdk-7-jre' # required by Solr
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

logrotate_app "youroute" do
  cookbook "logrotate"
  path "/srv/youroute/current/log/production.log"
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

runit_service "youroute-solr" do
  template_name "solr"
  log_template_name "solr"
  options(
    :rails_root => "/srv/youroute/current",
    :rails_env => "production"
  )
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

youroute_unicorn "youroute" do
  root         "/srv/youroute/current"
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "prod.youroute.ru", "youroute.ru" ]
  redirect_subdomains_at "youroute.ru"
end
