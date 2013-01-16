module CapyBrowser

  module Rake

    class RelativePath
      attr_reader :dirname, :path, :relative_path

      def initialize(path)
        @dirname = ENV['BUNDLE_GEMFILE'] # File.expand_path('../../../../',__FILE__)
        @path = relative path
        @relative_path = "./#{path}"
      end

      def relative(path)
        File.join(@dirname,path)
      end

      def exists?
        File.exists?(@path)
      end

      def modification_time
        File.mtime(@path).to_i
      end

      def more_recent?(other)
       ( modification_time > other.modification_time) rescue true
      end
    end
  end
end
