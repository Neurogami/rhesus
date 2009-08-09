require 'rubygems'
require 'bacon'
require 'lib/rhesus/core'

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

    #    vars.include?('adj1').should == true
    #   vars.include?('adj2').should == true
    #  vars.include?('adj3').should == true
  end

end

__END__

What are the key useful things we might want?

* List available templates
* Use one of those templates
