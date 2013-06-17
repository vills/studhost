maintainer       "Vil Surkin"
maintainer_email "vill.srk@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures thin, a fast and very simple Ruby web server"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ debian }.each do |os|
  supports os
end

depends "apache2"
