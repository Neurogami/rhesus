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

namespace :issues do
  desc 'Open issues'
  task :open do
    paged_issues ENV['GH_NO_CACHE']
  end

  desc 'Create a new issue'
  task :create do
    issue_details = ENV['DETAILS'].to_s.strip
    if issue_details.empty?
      warn "No issue details!"
    else
      title, body =  issue_details.split(' -- ', 2)
      create_issue  title, body 
    end
  end
end


def create_issue title, body
  require 'net/http'
  require 'uri'


  token = ENV['GH_AUTH_TOKEN']
  url = 'http://github.com/api/v2/yaml/issues/open/Neurogami/rhesus'
  res = Net::HTTP.post_form(URI.parse(url),
                            {'title'=> title, 
                                'body' => body,
                                'login' => 'Neurogami',
                                 'token'=> token }
                           )
                           warn res.body

end

def ___
  warn "\n" + '_' * 30
end

def paged_issues no_cache = false
  ARGV.clear 
  warn "Hit enter after each issue to see the next one"
  issues(no_cache).each do |issue|
    ___    
    warn "Title: #{issue['title']}"
    warn "Details: \n#{issue['body']}"
    ___
    gets
  end
  warn "\nThat's it!"
end


def issues no_cache = false
  issues_cache = 'issues.yaml'
  if no_cache || !File.exist?(issues_cache)
    warn "Reloading issues from GitHub ..."
    File.open( issues_cache, 'w'){ |f| f.puts get_issues }
  end
  YAML.load(IO.read(issues_cache))['issues']
end

def get_issues
  #require 'yaml'
  #   url = 'http://github.com/api/v2/yaml/issues/list/Neurogami/rhesus/open'  
  # open(url).read  

  %~--- 
issues: 
- user: Neurogami
  updated_at: 2009-08-25 11:15:11 -07:00
  body: "The  app started out to handle Ruby code, but is handy for almost anything (such as layout out a Haskel project).  But not all languages use the same CamelCase and snake_case conventions.  \r\n\
    \r\n\
    When the code is inventing file names it needs to follow appropriate language conventions. "
  title: All variable-driven file names are snake_cased by default
  number: 1
  votes: 0
  closed_at: 
  labels: 
  - configuration
  created_at: 2009-08-25 10:09:44 -07:00
  state: open
- user: Neurogami
  updated_at: 2009-08-25 10:16:28 -07:00
  body: |-
    Running 
    
         rhesus list
    
    or 
    
        rhesus gen
    
    gives a full list of available templates, which can get too big to be useful.
  title: CLI UI won't scale
  number: 2
  votes: 0
  closed_at: 
  labels: 
  - UI
  created_at: 2009-08-25 10:13:53 -07:00
  state: open
  ~
end

# EOF
