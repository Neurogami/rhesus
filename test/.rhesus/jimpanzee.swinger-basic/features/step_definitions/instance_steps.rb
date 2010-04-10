
# FIXME This seems fragile ...
# Can we invoke the app being test by passing a path to some code to be required,
# so that the app does not directly require the druby thing, and need
# not know where it is, but the test code has that info?
#require app_root  + 'src/druby' unless Module.const_defined? :Invoker



# Assumes you have already somehow defined $DrbInvoker
# as the invoker object, most likely in env.rb
def invoke_on_instance klass, method
  #$remote_invoker.invoke_on_instance klass, method
  DrbInvoker.invoker.invoke_on_instance klass, method
end


def invoke_on_controller_instance klass, method
  #$remote_invoker.invoke_on_instance "#{klass}Controller", method
  DrbInvoker.invoker.invoke_on_instance "#{klass}Controller", method
end


Given t(/^I activate the  "([^\"]*)" instance with "([^\"]*)"$/) do |klass, method|
  invoke_on_instance klass, method
end

Given t(/^I activate "([^\"]*)" with "([^\"]*)"$/) do |klass, method|
  klass.gsub!( ' ', '')
  invoke_on_controller_instance klass, method
end

Given t(/^I open "([^\"]*)"$/) do |klass|
  klass.gsub!( ' ', '')
  invoke_on_controller_instance klass, 'open'
end
