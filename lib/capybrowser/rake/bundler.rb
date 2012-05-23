module CapyBrowser
  module Rake
    class Bundler
      def initialize(gem)
        @gemdir   = CapyBrowser::Rake::RelativePath.new('tmp/vendor/bundle').path
        @bindir   = CapyBrowser::Rake::RelativePath.new('tmp/vendor/bin').path
        @bundler  = CapyBrowser::Rake::Executable.new 'bundle', %W(install --binstubs=#{@bindir} --path=#{@gemdir})
        @gem      = CapyBrowser::Rake::GemDependency.new(gem){|reference,sample| @bundler.invoke!  }
      end

      def invoke!
        @gem.invoke!
      end

      def cmdline
        @bundler.cmdline
      end
    end
  end
end
