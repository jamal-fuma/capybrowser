module CapyBrowser
  module Rake
    class GemDependency
      attr_reader :reference, :sample

      def initialize(gem,&update_callback)
        @gem       = gem
        @reference = gem.gemspec_path
        @sample    = gem.gemfile_path
        @update_callback = update_callback
        @file_time_updater = CapyBrowser::Rake::Executable.new 'touch',  [@reference.path,@sample.path]
      end

      def modified?
        modified = @reference.more_recent?(@sample)
        @update_callback.call(@reference,@sample) if modified
        modified
      end

      def invoke!
        if modified?
          @gem.invoke!
          @file_time_updater.invoke!
        end
      end

      def cmdline
        @file_time_updater.cmdline
      end
    end
  end
end
