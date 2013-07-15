[
  # packages for capybara-webkit gem
  'xvfb',
  'libqt4-dev',
  'libqtwebkit-dev'
].each do |name|
  package name do
    action :install
  end
end