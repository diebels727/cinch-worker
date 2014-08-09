# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ffaker"
  s.version = "1.24.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Emmanuel Oga"]
  s.date = "2014-04-02"
  s.description = "Faster Faker, generates dummy data."
  s.email = "EmmanuelOga@gmail.com"
  s.extra_rdoc_files = ["README.md", "LICENSE", "Changelog.md"]
  s.files = ["README.md", "LICENSE", "Changelog.md"]
  s.homepage = "http://github.com/emmanueloga/ffaker"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ffaker"
  s.rubygems_version = "2.0.14"
  s.summary = "Faster Faker, generates dummy data."

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.1.1"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
    else
      s.add_dependency(%q<rake>, ["~> 10.1.1"])
      s.add_dependency(%q<test-unit>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.1.1"])
    s.add_dependency(%q<test-unit>, [">= 0"])
  end
end
