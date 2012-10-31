action :create do
  template "/etc/nginx/sites-enabled/#{ new_resource.name }.local.conf" do
    source "nginx-unicorn.conf.erb"
    mode "644"
    owner "root"
    group "root"
    variables(
      :app_name => new_resource.name,
      :root => new_resource.root,
      :server_names => new_resource.server_names,
      :serve_precompiled_assets => new_resource.serve_precompiled_assets,
      :password_protection => new_resource.password_protection,
      :s3_bucket_name => new_resource.s3_bucket_name,
      :redirect_subdomains_at => new_resource.redirect_subdomains_at
    )
  end

  directory "/etc/unicorn/" do
    action :create
  end

  template "/etc/unicorn/config.default.rb" do
    source "config.default.rb"
    mode "644"
    owner "root"
    group "root"
  end

  unicorn_provider = new_resource # do not use new_provider inside blocks. it can be redefined there

  runit_service unicorn_provider.name do
    template_name "unicorn"
    log_template_name "unicorn"
    options({
      :rails_root => unicorn_provider.root,
      :rails_env => unicorn_provider.rails_env,
      :app_name => unicorn_provider.name,
      :shell => unicorn_provider.runit_shell,
      :user => unicorn_provider.runit_user,
      :group => unicorn_provider.runit_group
    })
  end

  logrotate_app unicorn_provider.name do
    cookbook "logrotate"
    path "#{unicorn_provider.root}/log/#{unicorn_provider.rails_env}.log"
    frequency "daily"
    rotate 30
    create "644 root adm"
    only_if unicorn_provider.logrotate
  end

  service "nginx" do
    action :restart
  end

  new_resource.updated_by_last_action(true)
end
