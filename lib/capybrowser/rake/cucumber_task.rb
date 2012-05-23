module CapyBrowser
  module Rake
    class CucumberTask
      attr_reader :target,:environment,:profile,:prefix
      def initialize(target,environment,url,prefix="")
        @target      = target
        @environment = environment
        @url         = url
        @profile     = "#{prefix}#{target}"
        @prefix      = prefix
      end

      def special_host?
        ([:production,:sandbox].include? @target)
      end

      def description
        "Run features against #{@target} environment at host #{self.app_host}"
      end

      def command_line(args)
        cmdline = []
        cmdline  << "-p #{@environment}"
        cmdline  << "-p #{@profile}"
        cmdline  << [args].flatten.join(" ")
        cmdline.join(" ")
      end

      def app_host
        url = [@url,@target.to_s]
        url.shift if special_host?
        url << 'bbc.co.uk'
        url.join('.')
      end
    end
  end
end
