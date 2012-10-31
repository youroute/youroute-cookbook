actions :create

attribute :name,                       :kind_of => String, :name_attribute => true
attribute :server_names,               :kind_of => Array, :default => nil
attribute :root,                       :kind_of => String
attribute :serve_precompiled_assets,   :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :password_protection,        :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :s3_bucket_name,             :kind_of => String, :default => "youroute-media"
attribute :runit_shell,                :kind_of => String, :default => "/bin/zsh"
attribute :runit_user,                 :kind_of => String, :default => "unicorn"
attribute :runit_group,                :kind_of => String, :default => "unicorn"
attribute :rails_env,                  :kind_of => String, :default => "production"
attribute :redirect_subdomains_at,     :kind_of => String, :default => nil
attribute :logrotate,                  :kind_of => [ TrueClass, FalseClass ], :default => true

def initialize(*args)
  super
  @action = :create
end