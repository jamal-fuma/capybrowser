require File.expand_path('../test_helper',__FILE__)

class Simple
  attr_accessor :title
  extend CapyBrowser::WrappedMethods
  named_constructors(:random){|method_name|
    [%q{args.join(" ") + ' ' +'} + method_name.to_s + %q{'}]
  }
  def initialize(title)
    @title = title
  end
end

class TestWrappedMethods < Test::Unit::TestCase
  include CapyBrowser::WrappedMethods
  def setup
    @obj = Class.new
  end

  def test_named_contructors
    expected = []
    expected << %q{def self.random(*args)}
    expected << %q{   begin}
    expected << %q{     Module.nesting[0].new(args.join(" ") + ' ' + 'random')}
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    expected << %q{end}
    actual = named_constructor_implementation(:random){|method_name|
      [%q{args.join(" ") + ' ' + '} + method_name.to_s + %q{'}]
    }.split("\n")

    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
    assert_equal expected.join("\n"), actual.join("\n")
    assert_nothing_raised {
      assert_equal "hello random", Simple.random("hello").title
    }
  end

  def test_named_constructor_implementation
    expected = []
    expected << %q{def self.foo(*args)}
    expected << %q{   begin}
    expected << %q{     Module.nesting[0].new(*args)}
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    expected << %q{end}
    actual = named_constructor_implementation(:foo){|method_name| ['*args'] }.split("\n")
    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
    assert_equal expected.join("\n"), actual.join("\n")
  end


  def test_wrapped_methods
    assert_raises(NoMethodError){
      @obj.live?
    }
    @obj.instance_eval do
      def live
        "foobar"
      end
      def dead
        raise "Blowing up now"
      end
      def unprotected
        raise "Blowing up now"
      end
      class << self
        self.extend CapyBrowser::WrappedMethods
        wrapped_methods :live,:dead
      end
    end
    assert_equal "foobar", @obj.live
    assert_match(/#{Regexp.escape("dead() failed ->\nBlowing up now")}$/, assert_raises(RuntimeError){ @obj.dead }.message)
    assert_equal "Blowing up now", assert_raises(RuntimeError){ @obj.unprotected }.message
  end

  def test_wrapped_methods_error
    assert_raises(NoMethodError){
      @obj.live?
    }
    assert_raises(RuntimeError){
      @obj.instance_eval do
        def live
          "foobar"
        end
        def dead
          raise "Blowing up now"
        end
        def unprotected
          raise "Blowing up now"
        end
        class << self
          self.extend CapyBrowser::WrappedMethods
          self.stubs(:wrapped_in_try_catch).raises(RuntimeError)
          wrapped_methods :live,:dead
        end
      end
    }
  end

  def test_wrapped_methods_error_mutators
    assert_raises(NoMethodError){
      @obj.live?
    }
    assert_raises(RuntimeError){
      @obj.instance_eval do
        def live=(foo)
        end
        class << self
          self.extend CapyBrowser::WrappedMethods
          self.stubs(:wrapped_in_try_catch).raises(RuntimeError)
          wrapped_methods :live=
        end
      end
    }
  end



  def test_wrapped_method_with_block_implementation
    expected = []
    expected << %q{alias_method :_wrapper_123_foo, :foo}
    expected << %q{def foo(*args,&block)}
    expected << %q{   begin}
    expected << %q{    (block.class.to_s == 'Proc') ? _wrapper_123_foo(*args,&block) : _wrapper_123_foo(*args)}
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    expected << %q{end}

    time = mock("time")
    time.expects(:to_f).once.returns(0)
    Time.expects(:now).once.returns(time)
    Kernel.expects(:rand).once.with(0).returns(123)
    actual = wrapped_method_with_block_implementation(:foo).split("\n")
    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
  end

  def test_generated_method_implementation
    impl = %q{     puts "hello"}
    expected = []
    expected << %q{def foo}
    expected << %q{   begin}
    expected << impl
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    expected << %q{end}
    actual = generated_method_implementation(:foo,'def METHOD_NAME',impl,'end').split("\n")
    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
    assert_equal expected.join("\n"), actual.join("\n")
  end

  def test_wrapped_in_try_catch
    impl = %q{     Module.nesting[0].new(*args)}
    expected = []
    expected << %q{   begin}
    expected << impl
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    actual = wrapped_in_try_catch(impl).split("\n")
    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
    assert_equal expected.join("\n"), actual.join("\n")
  end

  def test_wrapped_in_try_catch_error
    assert_raises(RuntimeError){
      actual = wrapped_in_try_catch(nil).split("\n")
    }
  end

  def test_wrapper_method_name
    time = mock("time")
    time.expects(:to_f).once.returns(0)
    Time.expects(:now).once.returns(time)
    Kernel.expects(:rand).once.with(0).returns(123)
    assert_equal "_wrapper_123_foo", wrapper_method_name(:foo)
  end

  def test_wrapper_method_name_error
    time = mock("time")
    time.stubs(:to_f).raises(RuntimeError)
    Time.expects(:now).once.returns(time)
    #Kernel.expects(:rand).once.with(0).returns(123)
    assert_raises(RuntimeError){
      assert_equal "_wrapper_123_foo", wrapper_method_name(:foo)
    }
  end


  def test_delgated_methods
    assert_raises(NoMethodError){
      @obj.to_blah
    }
    assert_raises(NoMethodError){
      @obj.empty?
    }

    @obj.instance_eval do
      def to_blah
        @title ||= ''
      end
      class << self
        self.extend CapyBrowser::WrappedMethods
        attr_accessor :title
        delegated_methods(:empty?){|method_name| 'self.to_blah' }
      end
    end
    assert_true @obj.empty?
    @obj.title = 'foobar'
    assert_equal 'foobar', @obj.to_blah
    assert_false @obj.empty?

  end

  def test_delgated_methods_error
    assert_raises(NoMethodError){
      @obj.to_blah
    }
    assert_raises(NoMethodError){
      @obj.empty?
    }
    assert_raises(RuntimeError){
      @obj.instance_eval do
        def to_blah
          nil
        end
        class << self
          self.extend CapyBrowser::WrappedMethods
          self.stubs(:generated_method_implementation).raises(RuntimeError)
          attr_accessor :title
          delegated_methods(:empty?){|method_name| 'self.to_blah' }
        end
      end
    }

    assert_nil @obj.to_blah
    @obj.title = ''
  end

  def test_delegated_methods_error_mutators
    assert_raises(NoMethodError){
      @obj.live?
    }
    assert_raises(RuntimeError){
      @obj.instance_eval do
        def live=(foo)
        end
        class << self
          self.extend CapyBrowser::WrappedMethods
          self.stubs(:wrapped_in_try_catch).raises(RuntimeError)
          delegated_methods(:live=){ |method_name| 'self.foobar' }
        end
      end
    }
  end



  def test_delegated_method_with_block_implementation
    expected = []
    expected << %q{def empty?(*args,&block)}
    expected << %q{   begin}
    expected << %q{    (block.class.to_s == 'Proc') ? self.to_s.empty?(*args,&block) : self.to_s.empty?(*args)}
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    expected << %q{end}
    actual = delgated_method_with_block_implementation(:empty?){|method_name| 'self.to_s' }.split("\n")
    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
  end

  def test_predicate_methods_simple_results
    assert_raises(NoMethodError){
      @obj.live?
    }
    @obj.instance_eval do
      class << self
        self.extend CapyBrowser::WrappedMethods
        predicate_methods(:live,:test){|env|
          result = case(env.to_s)
                   when 'live' :
                     true
                   when 'test' :
                     false
                   else
                     raise "unexpected string #{env}"
                   end
          [result]
        }
      end
    end
    assert_true  @obj.live?
    assert_false @obj.test?
  end

  def test_predicate_methods_simple_generation
    expected = []
    expected << %q{def live?}
    expected << %q{   begin}
    expected << %q{     true}
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    expected << %q{end}
    actual = predicate_method_implementation(:live){|method_name| ['true'] }.split("\n")
    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
    assert_equal expected.join("\n"), actual.join("\n")

    expected = []
    expected << %q{def test?}
    expected << %q{   begin}
    expected << %q{     false}
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    expected << %q{end}
    actual = predicate_method_implementation(:test){|method_name| ['false'] }.split("\n")
    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
    assert_equal expected.join("\n"), actual.join("\n")
  end

  def test_predicate_method_implementation
    expected = []
    expected << %q{def foo?}
    expected << %q{   begin}
    expected << %q{     raise "Cant find the name of the current environment" if self.name.nil?}
    expected << %q{     'foo' == self.name}
    expected << %q{   rescue}
    expected << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
    expected << %q{   end}
    expected << %q{end}
    actual = predicate_method_implementation(:foo){|method_name|
      code = []
      code << %q{raise "Cant find the name of the current environment" if self.name.nil?}
      code << %q{'METHOD_NAME' == self.name}
      code
    }.split("\n")
    expected.each_with_index{|expected_line,index|
      assert_equal expected_line, actual[index]
    }
    assert_equal expected.join("\n"), actual.join("\n")
  end
end
