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

  runit_options = {
    :rails_root => new_resource.root,
    :rails_env => new_resource.rails_env,
    :app_name => new_resource.name,
    :shell => new_resource.runit_shell,
    :user => new_resource.runit_user,
    :group => new_resource.runit_group
  }

  runit_service runit_options[:app_name] do
    template_name "unicorn"
    log_template_name "unicorn"
    options runit_options
  end

  logrotate_app new_resource.name do
    cookbook "logrotate"
    path "#{new_resource.root}/log/#{new_resource.rails_env}.log"
    frequency "daily"
    rotate 30
    create "644 root adm"
    only_if new_resource.logrotate
  end

  service "nginx" do
    action :restart
  end

  new_resource.updated_by_last_action(true)
end
