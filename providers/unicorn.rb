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
      :serve_precompiled_assets => new_resource.serve_precompiled_assets
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

  runit_service "gitlabhq" do
    template_name "unicorn"
    log_template_name "unicorn"
    options runit_options
  end
end
