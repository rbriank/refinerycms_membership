Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-memberships'
  s.version           = '2.0.1'
  s.description       = 'Ruby on Rails Memberships engine for Refinery CMS'
  s.authors           = 'Brian Kierstad,Angelo Grossini,Juozas Gaigalis,Sam Beam,others'
  s.date              = '2012-09-09'
  s.summary           = 'Memberships engine for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir['lib/**/*', 'config/**/*', 'app/**/*']

  s.add_dependency    'refinerycms-core',     '>= 2.0.0'
  s.add_dependency    'refinerycms-settings', '>= 2.0.0'

  s.add_dependency    'nokogiri', '~> 1.5.0'
  s.add_dependency    'webrat', '~> 0.7.3'
end
