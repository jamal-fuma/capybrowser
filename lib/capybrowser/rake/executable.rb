module CapyBrowser
  module Rake
    class Executable
      attr_reader :cmdline
      attr_accessor :arguments

      def initialize(path,arguments=[])
        @path = path
        @arguments = [arguments].flatten
      end

      def invoke!
        puts self.cmdline if ENV['VERBOSE']
        s = %x[#{self.cmdline}]
        puts s
        s
      end

      def cmdline
        [@path,@arguments].flatten.join(" ")
      end

      def self.rcov(options=[])
        Executable.new(CapyBrowser::Rake::RelativePath.new("tmp/vendor/bin/rcov").relative_path,options)
      end

      def self.rake(options=[])
        Executable.new(CapyBrowser::Rake::RelativePath.new("tmp/vendor/bin/rake").relative_path,options)
      end

      def self.cucumber(options=[])
        Executable.new("bundle exec rcov tmp/vendor/bin/cucumber",options)
      end

      def self.gem(options=[])
        Executable.new("gem",options)
      end
    end
  end
end
