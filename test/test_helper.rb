# Code coverage setup
require 'simplecov'
SimpleCov.start do
  add_group 'Libraries', 'lib'
  add_filter '/test/'
  add_filter 'init.rb'
  root File.expand_path(File.dirname(__FILE__) << '/../')
  coverage_dir 'tmp/coverage'
end

# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) << '/../../../test/test_helper')

# Load factories
factories_folder = File.expand_path File.dirname(__FILE__) << '/factories/'
FactoryGirl.definition_file_paths << factories_folder
FactoryGirl.find_definitions

# Including FactoryGirl methods in test classes
base = ActiveSupport::TestCase
methods = FactoryGirl::Syntax::Methods
base.send :include, methods unless base.included_modules.include? methods

# Including support modules
Dir.glob(File.dirname(__FILE__) << '/support/*_support.rb').each do |file|
  require file
end

# Including support for unit tests
base = ActiveSupport::TestCase
support = SetupSupport
base.send :include, support unless base.included_modules.include? support

# Including supprot for functional tests
base = ActionController::TestCase
modules = [LoginSupport, SetupSupport]
modules.each do |support|
  base.send :include, support unless base.included_modules.include? support
end
