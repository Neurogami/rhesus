require 'pp'
require 'erb'

class String
  def to_snake_case
    snake_case self
  end

  def to_camel_case
    camelize self
  end

  #def identifier_to_path!
  #  self.gsub! ':', '/' 
  #end
end

module Neurogami
  module Rhesus

    class Core

      # http://refactormycode.com/codes/281-given-a-hash-of-variables-render-an-erb-template
      @@m = Module.new do
        class << self
          public :binding
          def meta
            class << self; self; end
          end
        end

        class << meta
          public :define_method
        end

      end

      def self.create_methods_from_hash variables_hash
        variables_hash.each do |name, value|
          @@m.meta.define_method(name) { value }
        end
      end

      def self.process_template template_text, variables_hash
        create_methods_from_hash variables_hash
        t = ERB.new(template_text, 0, "%<>")
        t.result @@m.binding
      end

      def self.projects
        get_projects_directories.map { |path|
          path.sub! user_template_directory + '/', ''
          path
        }
      end

      def self.tuple_base_name_pair name
        [snake_case(name), camelize(name)]
      end


      #  
      def self.required_vars_for_template_set template_name
        #template_name.identifier_to_path!
        vars = {}

        selected_template_files(template_name).map do |path|
          next unless File.file? path
          next unless path =~ @@re
          file_lines = IO.readlines path
          file_lines.each do |v|
            vars[v] = v
          end
        end
        vars.keys.sort
      end

      def self.templates
        get_project_template_files.map do |path|
          # Remove the base path
          path.sub! user_template_directory + '/', ''
          path
        end
      end

      def self.required_vars file_lines
        vars = []
        file_lines.each do |l|
          vars.concat l.scan(/(<%=)\s*(\S+)\s*(%>)/).map{ |m| m[1].strip.split('.').first}
          #variables.each do |v|
          #  vars[v] = v
          #end
        end
        vars.uniq
      end




      # Isolate any methods that touch the file system so we can test more easily
      def self.get_projects_directories
        Dir.glob user_template_directory + '/*'
      end

      def self.get_project_template_files
        Dir.glob user_template_directory + '/*'
      end

      def self.selected_template_files template_name
        Dir.glob( user_template_directory + '/' + template_name + '/**/*', File::FNM_DOTMATCH).select { |f| f !~ /\.$/ }
      end

      def self.add_user_haz_vars haz_vars
        if File.exist?(File.expand_path( user_template_directory + '/haz_vars.txt'))
          IO.readlines(File.expand_path( user_template_directory + '/haz_vars.txt')).each { |x| haz_vars  << x.strip  unless x.strip.empty? }
        end
      end

      def self.user_dir_exists?
        File.exists? user_template_directory
      end

      def self.user_template_directory
        File.expand_path "~/.rhesus"
      end

      # How can this be tested?  This method is more or less the core of the
      # tool (other key method: extracting the set of vars from the templates)
      # The trouble is that the code works by creating a side effect; the return
      # value is nothing.
      #
      # This method does multiple things: computes file paths;
      # alters file path  basedon variable values;  calls
      # out to read in file text, alter it with variable subsition, and
      # write it out; do direct file copies.

      def self.process template_name, var_set, location, path
        relative_path  = path.sub user_template_directory , ''
        short_path = path.sub user_template_directory, ''
        real_path = short_path.sub(template_name + '/', '')
        var_set.each { |k,v| real_path.gsub!( k, v.to_snake_case ) }
        write_to = location + real_path 
        destination_dir = File.expand_path(File.dirname(write_to))
        FileUtils.mkdir_p destination_dir
        file_to_write_to  = File.expand_path write_to
        rename( file_to_write_to ) if File.exist? file_to_write_to 
        # Do a straight file copy unless this file might be using Erb
        if path =~ @@re
          source_text = IO.read path
          text = process_template source_text, var_set 
          File.open(file_to_write_to, "w"){|f| f.puts text }
        else
          FileUtils.cp path, file_to_write_to
        end
      end


      def self.rename full_file_path
        ts = Time.now.to_i.to_s
        FileUtils.mv full_file_path, full_file_path + '.' + ts 
      end


      # Hacky :( FIXME Add a better way to define what files get slurped for parsing
      haz_vars = %w{ rb txt rhtml ini yml yaml Rakefile rake gemspec feature}
      add_user_haz_vars haz_vars 
      @@re = haz_vars.map { |x|   x + '$' }.join( '|') 
      @@re = Regexp.new "(#{@@re})$"

    end
  end
end
