module CapyBrowser
  module Rake
    class Coverage
      attr_reader :excluded_files,:included_files
      attr_reader :rcov,:cucumber

      def initialize(opts={})
        @options = { :rcov_opts => "", :cuke_opts => "" }.merge(opts)
        @rcov = Executable.rcov(rcov_options)
        @cucumber = Executable.cucumber([rcov_options,cucumber_options].join(" -- "))
      end

      def rcov_options
        opts = [ "-I #{RelativePath.new('lib').relative_path}" ]
        opts << "--aggregate #{
          RelativePath.new('tmp/doc/coverage/rcov.data').relative_path
        }"
        opts << '--sort coverage'
        opts << "--html -o #{
          RelativePath.new('tmp/doc/coverage').path
        }"
        opts << '--text-summary --no-color'
        opts << '--profile'
        opts << "--exclude #{
          %w(/gems/ /Library/ /usr/ tmp).join(",")
        }"
        [opts.join(" ") ,@options[:rcov_opts]].flatten.join(" ")
      end

      def cucumber_options
        opts = ENV['CUKE_OPTS'] ?  "#{ENV['CUKE_OPTS']}" : ""
        [opts,@options[:cuke_opts]].flatten.join(" ")
      end
    end
  end
end
