require 'drb'

class Invoker

  URI ="druby://localhost:8787" 

  def ping
    true
  end

  def invoke_on_instance instance_name, method, *args
    warn "Invoke #{instance_name}##{method}"
    instance = Object.const_get(instance_name).instance
    if args && args.size > 0
      instance.send method, *args
    else
      instance.send method
    end
  end

  def self.run
    DRb.start_service Invoker::URI, Invoker.new
    warn DRb.uri
  end
end

