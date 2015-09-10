# Load the Redmine helper
require File.expand_path File.dirname(__FILE__) << '/../../../test/test_helper'
# Load factories
factories_folder = File.expand_path File.dirname(__FILE__) << '/factories/'
FactoryGirl.definition_file_paths << factories_folder
FactoryGirl.find_definitions

# Including factoryGirl methods in test classes
methods = FactoryGirl::Syntax::Methods
classes = [ActiveSupport::TestCase]
classes.each do |base|
  base.send :include, methods unless base.included_modules.include? methods
end
