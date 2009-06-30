require 'rubygems'
require 'bacon'
require 'lib/rhesus/core'

describe 'A rhesus directory' do

  before do
    @nrc = Neurogami::Rhesus::Core
    class Neurogami::Rhesus::Core
      #def self.user_template_directory
      #   "~/.rhesus"
      #end

    end

  end


  it 'should be in the home directory' do
    @nrc.user_template_directory.should.equal '/home/james/.rhesus'
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


  #it 'should have 4 files in the monkeybars:about template set' do
  #end

  #it 'returns a project template reference given the qualified name "monkeybars:about"' do
  #  pt = @nrc.get "monkeybars:about"
  #  pt.class.should.equal Neurogami::Rhesus::TemplateSet 
  #end

end

__END__

What are the key useful things we might want?

* List available templates
* Use one of those templates
