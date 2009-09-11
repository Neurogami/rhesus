module Neurogami
  module Rhesus

    module Common

      module ClassMethods

        def user_dir_exists?
          File.exists? user_template_directory
        end

        def user_template_directory
          File.expand_path "~/.rhesus"
        end
      end



      def self.included(base)
        base.extend(ClassMethods)
      end

    end


  end
end
