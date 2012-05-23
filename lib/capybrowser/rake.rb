require File.expand_path('../rake/executable',__FILE__)
require File.expand_path('../rake/coverage',__FILE__)
require File.expand_path('../rake/gem',__FILE__)
require File.expand_path('../rake/bundler',__FILE__)
require File.expand_path('../rake/cucumber_task',__FILE__)
require File.expand_path('../rake/relative_path.rb',__FILE__)
require File.expand_path('../rake/gem_dependency',__FILE__)

module CapyBrowser
  module Rake
    def paths
      [
        RelativePath.new('tmp/doc'),
        RelativePath.new('tmp/log'),
        RelativePath.new('tmp/gems'),
        RelativePath.new('tmp/metrics'),
        RelativePath.new('tmp/doc/coverage'),
        RelativePath.new('tmp/doc/tests/junit'),
        RelativePath.new('tmp/doc/cucumber/junit'),
        RelativePath.new('tmp/doc/cucumber/text'),
        RelativePath.new('tmp/doc/cucumber/html')
      ]
    end

    def directories
      paths.map(&:path.to_proc)
    end

    def dependencies
      rake_directories
    end

    def rake_directories
      paths.map(&:relative_path.to_proc)
    end

    def rake(options="")
      puts "calling rake" if ENV["VERBOSE"]
      Executable.rake(options)
    end

    def rcov(options="")
      puts "calling rcov" if ENV["VERBOSE"]
      Coverage.new({:rcov_opts => options}).rcov
    end

    def cucumber(options="")
      puts "calling cucumber" if ENV["VERBOSE"]
      Coverage.new({:cuke_opts =>options}).cucumber
    end

    module_function :rake,:rcov,:cucumber,:dependencies,:directories,:paths, :rake_directories
  end
end
