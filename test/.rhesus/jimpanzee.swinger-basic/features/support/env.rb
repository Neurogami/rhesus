require 'java'
require 'pp'

here = File.expand_path(File.dirname(__FILE__))

app_root = here + '/../../'

require  app_root + '/<%= swinger_submodule_dir %>/swinger/lib/swinger/jemmy.jar'
java_import org.netbeans.jemmy.ClassReference

require app_root  + '/src/resolver'
require File.expand_path( app_root + '/package/jar/<%= app_jar_name %>.jar')



puts "It takes a while for the scenarios to begin executing, so please be patient..."

Thread.new do  
  app = ClassReference.new("org.rubyforge.rawr.Main")
  warn "Starting the  application ..."
  app.startApplication
end


class DrbInvoker
  @@invoker = nil
  def self.get_invoker
    begin
      @@invoker = DRbObject.new nil,  Invoker::URI
      @@invoker.ping
    rescue DRb::DRbConnError => e
      warn "e = #{e.inspect}"
      sleep 5
      retry
    end 
    warn @@invoker.ping
    @@invoker
  end

  def self.invoker
    @@invoker ||= get_invoker
  end
end

require app_root  + 'src/druby'  # unless Module.const_defined? :Invoker
DrbInvoker.invoker

require  app_root + '/<%= swinger_submodule_dir %>/swinger/lib/swinger'

at_exit do 
  java.lang.System.exit 0
end


