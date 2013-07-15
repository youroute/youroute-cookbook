include_recipe 'locale-gen'
include_recipe 'locale'

[
  'console-cyrillic',
  'language-pack-ru'
].each do |name|
  package name do
    action :install
  end
end