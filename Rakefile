# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'version'

task :default => 'test:bacon'

PROJ.name = 'rhesus'
PROJ.authors = 'James Britt / Neurogami'
PROJ.email = 'james@neurogami.com'
PROJ.url = 'http://code.neurogami.com'
PROJ.version = Neurogami::Rhesus::VERSION
PROJ.readme_file = 'README.md'
PROJ.summary = "Really simple, practical code generator."


desc "Bacon specs"
task 'test:bacon' do
  sh "bacon test/test_rhesus.rb"
end


desc 'test'
task :test => 'test:bacon'
# EOF
