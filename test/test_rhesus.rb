require 'rubygems'
require 'bacon'

h = File.expand_path(File.dirname(__FILE__))
$:.unshift h + '/../lib/'

require 'rhesus'

#require 'lib/rhesus/core'
#require 'lib/rhesus/installer'


require 'mockfs'


$here = File.expand_path(File.dirname(__FILE__))

describe 'A rhesus directory' do

  before do

    @nrc = Neurogami::Rhesus::Core
    class Neurogami::Rhesus::Core
      def self.user_template_directory
         "#{$here}/.rhesus"
      end
    end

  end

  # Not all that useful ....
  it 'should be in the home directory' do
    @nrc.user_template_directory.should.equal $here  + '/.rhesus'
  end

  it 'should exist' do
    @nrc.user_dir_exists?.should.equal true
  end

  it 'should not be empty ' do
    @nrc.projects.size.should.not.equal 0
  end

  it 'should hold 5 project templates ' do
    @nrc.templates.size.should.equal 5
  end

end

describe 'The core Rhesus code' do

  it 'really needs to populate an Erb string with key/value pairs' do
    template_text = "I've got <%= adj1 %>, \nand I'm <%= adj2 %> <%= adj3 %>"
    variable_set = { :adj1 => 'soul' , :adj2 => 'super', :adj3 => 'bad' }
    new_text = Neurogami::Rhesus::Core.process_template template_text, variable_set 
    new_text.should ==   "I've got soul, \nand I'm super bad"
  end

  it 'dang well better extract variable names from Erb, bro' do
    template_text = "I've got <%= adj1 %>, \nand I'm <%= adj2 %> <%= adj3 %>. And I mean <%= adj2 %> <%= adj3 %>"

    vars = Neurogami::Rhesus::Core.required_vars template_text.split( "\n")
    vars.sort!
    vars.should  == ['adj1', 'adj2', 'adj3' ]

  end

  
  it 'needs to know when a file with Erb is not meant to be interpolated' do

    template_text = "Hey! \n<|= zoobar |> got <%= _adj1 %>, \nand I'm <%= _adj2 %> <%= _adj3 %>. And <|= goober |> mean <%= _adj2 %> <%= _adj3 %>"

    vars = Neurogami::Rhesus::Core.required_vars( template_text.split( "\n"), :rhemazar )
    vars.sort!
    vars.should  == ['goober', 'zoobar' ]

  end


   
  it 'needs to handle rhezamar templating' do

    variables_hash =  {'zoobar' => 'Jimbo', 'goober' => 'Goober' }
    template_text = "<|= zoobar |> got <%= _adj1 %>, \nand I'm <%= _adj2 %> <%= _adj3 %>. And <|= goober |> mean <%= _adj2 %> <%= _adj3 %>"
    expected = "Jimbo got <%= _adj1 %>, \nand I'm <%= _adj2 %> <%= _adj3 %>. And Goober mean <%= _adj2 %> <%= _adj3 %>"
    t = Neurogami::Rhesus::Rhezamar.new template_text
    results = t.result variables_hash
    results.should.equal expected

    
  end
end

describe 'The Rhesus installer' do
  MockFS.mock = true

  it 'determines the repo type from a given URL' do
    repo_url = 'git://github.com/Neurogami/gae.ramaze.git'
    Neurogami::Rhesus::Core.repo_type(repo_url).should.equal :git
    repo_url = 'svn://foohub.com/Neurogami/gae.ramaze'
    Neurogami::Rhesus::Core.repo_type(repo_url).should.equal :unknown
    repo_url = 'git@github.com:Neurogami/Jimpanzee.git'
    Neurogami::Rhesus::Core.repo_type(repo_url).should.equal :git
    repo_url = 'git#foohub.com/Neurogami/gae.ramaze'
    Neurogami::Rhesus::Core.repo_type(repo_url).should.equal :unknown

  end

it 'determines the destination folder name from the repo URL' do
    repo_url =  'git://github.com/Neurogami/gae.ramaze.git'
    Neurogami::Rhesus::Core.destination_folder_name(repo_url).should.equal "gae.ramaze"
end

  it 'would be super-duper if it handled a git repo URL as a means to install a new template' do
    repo_url =  'git://github.com/Neurogami/gae.ramaze.git'

    lambda { Neurogami::Rhesus::Installer.install_from_repo repo_url }.should.not.raise(Neurogami::Rhesus::InstallationError)


  end


#  it 'knows when a repo URL is valid' do
#    repo_url =  'git@github.com:Neurogami/andi.git'
#    Neurogami::Rhesus::Installer.is_valid_repo_url?(repo_url).should.equal true

#  end

#  it 'can pull out repo URL parts' do

#   end

  MockFS.mock = false

end
