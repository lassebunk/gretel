Gem::Specification.new do |s|
  s.name = "gretel"
  s.version = "1.2.1"

  s.author = "Lasse Bunk"
  s.email = "lassebunk@gmail.com"
  s.description = "Gretel is a Ruby on Rails plugin that makes it easy yet flexible to create breadcrumbs."
  s.summary = "Flexible Ruby on Rails breadcrumbs plugin."
  s.homepage = "http://github.com/lassebunk/gretel"
  
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "rails", "~> 3.2.11"
  s.add_development_dependency "sqlite3"
end