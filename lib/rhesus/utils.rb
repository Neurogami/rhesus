require 'fileutils'
require 'rhesus/core'

def snake_case name 
  name.gsub(/\B[A-Z]/, '_\&').downcase
end

def template_base_dir 
  File.expand_path( File.join( File.dirname(__FILE__), '..', 'templates' ) )
end

#def copy_over_prebuilt_template base_path, name
#  %w{model view controller ui}.each do |unit|
#    FileUtils.mkdir_p File.join(base_path, name)
#    from = File.join( template_base_dir, name , name + '_' + unit + '.rb')
#    dest = File.join(base_path, name, name + '_' + unit + '.rb' )
#    warn "cp '#{from}' to '#{dest}'"
#    FileUtils.cp from, dest 
#  end
#end

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
