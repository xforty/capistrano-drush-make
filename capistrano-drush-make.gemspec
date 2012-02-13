Gem::Specification.new do |s|
  s.name        = 'capistrano-drush-make'
  s.version     = '0.1.0'
  s.summary     = "Deployment strategy for Drupal drush makefiles"
  s.description = "Drush makefiles are used to build a drupal code base with specific version.  This gem focused on deploying with those makefiles"
  s.authors     = ["Christian Pearce"]
  s.email       = 'pearcec@xforty.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/xforty/capistrano-drush-make'
  s.require_paths = ["lib"]
  s.extra_rdoc_files = [
    "README.md"
  ]

  s.add_runtime_dependency(%q<capistrano>, [">=2.0"])
end
