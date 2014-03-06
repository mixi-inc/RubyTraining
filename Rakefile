require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:activerecord)
PadrinoTasks.init

task :default => [:spec]
desc 'run Rspec specs'
task :spec do
  sh 'rspec'
end
