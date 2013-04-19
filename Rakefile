#require 'rake'
#require 'rake/testtask'
#require 'rake/rdoctask'
 
# Dir["#{File.dirname(__FILE__)}/_tasks/*.rake"].sort.each { |ext| load ext }

require "#{Dir.pwd}/app"

desc 'Migrate DataMapper database'
task :upgradedb do
  DataMapper.auto_upgrade!
end