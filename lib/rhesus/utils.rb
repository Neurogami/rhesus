require 'fileutils'
require 'rhesus/core'

def snake_case name 
  name.gsub(/\B[A-Z]/, '_\&').downcase
end

def template_base_dir 
  File.expand_path( File.join( File.dirname(__FILE__), '..', 'templates' ) )
end

def setup_directory path
  FileUtils.mkdir_p path.gsub("\\", "/")
  FileUtils.cd path
  path.split("/").last
end

def camelize name, first_letter_in_uppercase = true
  name = name.to_s
  if first_letter_in_uppercase
    name.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  else
    name[0..0] + camelize( name[1..-1])
  end
end
