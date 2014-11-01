require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.fail_on_warnings = true

# http://puppet-lint.com/checks/class_parameter_defaults/
PuppetLint.configuration.send('disable_class_parameter_defaults')
# http://puppet-lint.com/checks/class_inherits_from_params_class/
PuppetLint.configuration.send('disable_class_inherits_from_params_class')

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc 'Run the acceptance tests with the default Beaker node'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Run acceptance tests against all beaker nodes'
task :acceptance_all do
  hosts = Dir.glob(File.join('spec', 'acceptance', 'nodesets', '*.yml')).collect { |file| File.basename(file, '.yml') }
  hosts.sort.each_with_index do |host,index|
    ENV['BEAKER_set'] = host
    puts "Testing host: #{host}"
    if index == 0
      Rake::Task['acceptance'].invoke
    else
      Rake::Task['acceptance'].reenable
      Rake::Task['acceptance'].invoke
    end
  end
end

desc 'Prepare running the acceptance tests by starting the Beaker nodes'
task :acceptance_prep do
  ENV['RS_DESTROY'] = 'no'
  Rake::Task['acceptance'].invoke
end

desc 'Run the acceptance tests with the existing Beaker nodes'
task :acceptance_standalone do
  ENV['RS_DESTROY'] = 'no'
  ENV['RS_PROVISION'] = 'no'
  Rake::Task['acceptance'].invoke
end

task :test => [
  :syntax,
  :lint,
  :spec,
]
