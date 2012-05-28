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

# Create ssh deploy-wrapper
cookbook_file "/tmp/wrap-ssh4git.sh" do
  source "wrap-ssh4git.sh"
  owner "vagrant"
  mode 0700
end

deploy_revision "youroute" do
  repository "git://github.com/youroute/youroute.git"
  branch "develop"
  user "ubuntu"
  deploy_to "/srv/youroute"
  environment 'production'
  action :deploy
  ssh_wrapper "/tmp/wrap-ssh4git.sh"
  before_migrate do
    link "#{release_path}/vendor/bundle" do
      to "#{node[:gitlabhq][:path]}/shared/vendor_bundle"
    end
    execute "bundle install --deployment --without test development" do
      # ignore_failure true
      cwd release_path
    end
    execute "rake assets:precompile" do
      cwd release_path
    end
  end

  # symlink_before_migrate({
  #   "gitlab.yml" => "config/gitlab.yml",
  #   "database.yml" => "config/database.yml"
  # })

  migrate true
  migration_command "bundle exec rake db:setup"
end