
module Neurogami
  module Rhesus

    class InstallationError < Exception
    end

    class Installer

      
     include Neurogami::Rhesus::Common

      class << self


        def install_from_repo repo_url
          raise InstallationError.new("No ~/.rhesus folder") unless user_dir_exists?
          begin 
          Dir.chdir(user_template_directory) do
           git_repo_clone repo_url
         end
          rescue Exception
              raise InstallationError.new("Error cloning repo: #{$!}")
          end
        end


        def git_repo_clone repo_url
          warn  `git clone #{repo_url}`
        end

      end
    end
  end
end
