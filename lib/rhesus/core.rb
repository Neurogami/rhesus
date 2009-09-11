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

      include Neurogami::Rhesus::Common


      ERB_RE = {
        :ruby_erb => /(<%=)\s*(\S+)\s*(%>)/,
        :rhemazar => /(<\|=\s*)(\S+)(\s*\|>)/

      }
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

      # Can something be added so that if this is actual Erb content it
      # is processed using not-Erb? 
      def self.process_template template_text, variables_hash, erb  = :ruby_erb
        if variables_hash.empty?
          return template_text
        end

        # :rhemazar : :ruby_erb
        create_methods_from_hash variables_hash
        case erb
        when :eruby_erb
          t = ERB.new(template_text, 0, "%<>")
          t.result @@m.binding
        when :rhemazar 
          t = Neurogami::Rhesus::Rhezamar.new template_text
          t.result variables_hash
        else
          t = ERB.new(template_text, 0, "%<>")
          t.result @@m.binding
        end

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


      # Trouble: Suppose your template set includes a file, index.xhtml, and 
      # that file is meant to be an Erb template.  The <%= foo %> stuff inside
      # is exactly what should be copied over; it should *not* be preprocessed.
      #
      # How can Rhesus be told to not preprocess some file? It's tricky, if you want,
      # for example, to have a file that has Rhesus-substitution AND do-not-touch Erb. 
      # One option could be to have certain file types use a different Rhesus-magic
      # variable syntax:
      #
      #     <?r=   ?>  in place of <%= %>
      #  
      # Perhaps files that need special treatment can have some magic comment up top?
      # Too fugly?
      #
      # Thu Sep 10 23:01:43 MST 2009
      #   Using a modifued version of Ezamar engine.
      # Still need a nice way to indicate when this is to be used;
      # current approach has RHEMAZAR in the first line of the file, which
      # should get striped
      def self.required_vars_for_template_set template_name

        vars = []

        selected_template_files(template_name).map do |path|
          next unless File.file? path
          next unless path =~ @@re
          next if  ignore(path, @@options['ignore'])

          next if path =~ /\.git$/
          load_options template_name
          next  if no_parse( path, @@options['noparse']   ) 
          next if  ignore(path, @@options['ignore'])

          file_lines = IO.readlines path
          top_line = file_lines.first

          erb = :ruby_erb 
          if top_line =~ /RHEMAZAR/  
            file_lines.shift
            erb = :rhemazar
          end
          vars.concat required_vars(file_lines, erb)
        end
        vars.uniq!
        vars.sort
      end

      def self.templates
        get_project_template_files.map do |path|
          # Remove the base path
          path.sub! user_template_directory + '/', ''
          path
        end
      end

      def self.required_vars file_lines, erb_style = :ruby_erb

        if erb_style == :rhemazar
        end
        vars = []
        file_lines.each do |l|
          # XXX
          re = ERB_RE[erb_style]
          _v = l.scan( ERB_RE[erb_style] ).map do |m| 
            m[1].strip.split('.').first
          end

          unless _v.to_s.strip.empty?
            vars.concat  _v
          end
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


      def self.language_appropriate_renaming path, template_var, given_value
        # Hack to see what might work:
        renaming_map = {
          /\.rb$/ => :to_snake_case
        }
        renaming_map.each do |file_pattern, renaming_method|
          if path =~ file_pattern
            return path.gsub( template_var, given_value.send(renaming_method) )
          end
        end
        path.gsub( template_var, given_value )
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

        return if ignore(path, @@options['ignore'])

        var_set.each { |key, value| real_path = language_appropriate_renaming( real_path, key, value ) }

        write_to = location + real_path 
        destination_dir = File.expand_path(File.dirname(write_to))
        FileUtils.mkdir_p destination_dir
        file_to_write_to  = File.expand_path write_to
        rename( file_to_write_to ) if File.exist? file_to_write_to 


        # Do a straight file copy unless this file might be using Erb

        if path =~ @@re && !no_parse( path, @@options['noparse']   )

          source_text = IO.readlines path
          # A shame we read each file twice FIXME
          top_line = source_text.first

          erb = :ruby_erb 
          if top_line =~ /RHEMAZAR/  
            erb = :rhemazar
            source_text.shift
          end

          text = process_template source_text.join, var_set, erb
          warn "Create #{file_to_write_to}"

          File.open(file_to_write_to, "w"){|f| f.puts text }
        else
          warn "Copy #{path} to #{file_to_write_to}"
          FileUtils.cp path, file_to_write_to
        end
      end


      def self.ignore path, ignore_filters 
        return false if ignore_filters.nil?  || ignore_filters.empty?
        ignore_filters.each do |patt|
          return true if path =~ patt
        end
        false
      end
      def self.no_parse path,  no_parse_filters = []
        return false if no_parse_filters.nil? or no_parse_filters.empty?
        no_parse_filters.each do |patt|
          return true if path =~ patt
        end
        false
      end

      def self.load_options template_name
        full_path = user_template_directory + '/' + template_name 

        @@options ||= if File.exist? full_path+ '/.options.yaml'
                        o = YAML.load(IO.read( full_path + '/.options.yaml'))
          o['noparse'] ||= []
          o['noparse'].map!{ |patt| Regexp.new(Regexp.escape(patt)) }
          o['ignore'] ||= []
          o['ignore'] << '.options.yaml'
          o['ignore'].map!{ |patt| Regexp.new(Regexp.escape(patt)) }
          o
                      else
                        {}
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
