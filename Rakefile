require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

require File.expand_path('../tasks/task_helper',__FILE__)
import File.expand_path('../tasks/directories.rake',__FILE__)
import File.expand_path('../tasks/units.rake',__FILE__)
import File.expand_path('../tasks/report.rake',__FILE__)

task :default => :build

task :setup  => [:create_directories]
task :clean  => [:remove_directories]
task :units    => [:clean,:setup,:run_units]
task :coverage => [:clean,:setup,:run_units_coverage]
