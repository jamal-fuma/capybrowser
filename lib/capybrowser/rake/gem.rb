module CapyBrowser
  module Rake
    class Gem
      attr_reader :gemspec, :gemspec_path,:gemfile_path
      attr_reader :name, :version
      def initialize(name,version)
        @name = name
        @version = version
        @gemspec = "#{@name}.gemspec"
        @gemfile = "#{@name}-#{@version}.gem"
        @builder = Executable.gem(['build',@gemspec])
        @gemspec_path = RelativePath.new(@gemspec)
        @gemfile_path = RelativePath.new(@gemfile)
        @vendor_path = RelativePath.new('vendor/cache')
        @tmpdir_path = RelativePath.new('tmp/gems')
      end

      def invoke!
        puts "About to run #{self.cmdline}"
        results = %x[#{self.cmdline}]
        [ @vendor_path.path , @tmpdir_path.path ].each{|path| FileUtils.cp @gemfile, path }
        FileUtils.rm(@gemfile)
        results
      end

      def cmdline
        @builder.cmdline
      end

      def build_description
        "Build the #{@name} gem"
      end
      def build_gemfile_description
        "Build the #{@gemfile}"
      end
      def gemfile
        "./tmp/gems/#{@gemfile}"
      end
      def gemfile_exists?
        @gemfile_path.exists?
      end
     def gemspec_exists?
        @gemspec_path.exists?
      end
    end
  end
end
