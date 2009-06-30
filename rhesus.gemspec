# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rhesus}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Britt / Neurogami"]
  s.date = %q{2009-06-30}
  s.default_executable = %q{rhesus}
  s.description = %q{Rhesus is a script for copying over pre-built templates with optional embedded Erb stuff.

It started as a way to make jump-starting Monkeybars apps easier, but the user-defined
tempaltes need not have anything to do with Monkeybars.}
  s.email = %q{james@neurogami.com}
  s.executables = ["rhesus"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "bin/rhesus"]
  s.files = [ "History.txt", "Manifest.txt", "README.md", "Rakefile", "bin/rhesus", "lib/rhesus.rb", "lib/rhesus/core.rb", "lib/rhesus/utils.rb", "lib/templates/about/about_controller.rb", "lib/templates/about/about_model.rb", "lib/templates/about/about_ui.rb", "lib/templates/about/about_view.rb", "lib/templates/basic/basic_controller.rb", "lib/templates/basic/basic_model.rb", "lib/templates/basic/basic_ui.rb", "lib/templates/basic/basic_view.rb", "lib/version.rb",  "spec/rhesus_spec.rb", "spec/spec_helper.rb", "test/.bacon", "test/test_rhesus.rb"]
  s.homepage = %q{http://code.neurogami.com}
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ }
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Really simple, practical code generator.}
  s.test_files = ["test/test_rhesus.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.5.0"])
    else
      s.add_dependency(%q<bones>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.5.0"])
  end
end
