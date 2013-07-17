module Utils
  def install_packages(packages = [])
    packages.each do |name|
      package name do
        action :install
      end
    end
  end
end