module CapyBrowser
  module Rake
    class Coverage
      attr_reader :excluded_files,:included_files
      attr_reader :cucumber

      def initialize(opts={})
        @options = { :cuke_opts => "" }.merge(opts)
        @cucumber = Executable.cucumber([cucumber_options].join(" -- "))
      end

      def cucumber_options
        opts = ENV['CUKE_OPTS'] ?  "#{ENV['CUKE_OPTS']}" : ""
        [opts,@options[:cuke_opts]].flatten.join(" ")
      end
    end
  end
end
