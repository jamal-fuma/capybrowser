module CapyBrowser
  module WrappedMethods
    SPECIAL_METHOD_REGEX = /[=+]$/

    def wrapped_methods(*methods)
      begin
        methods.each{|method_name|
          self.class_eval wrapped_method_with_block_implementation(method_name)
        }
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def wrapper_method_name(method_name)
      begin
        "_wrapper_#{ Kernel.rand Time.now.to_f }_#{method_name}"
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def wrapped_method_with_block_implementation(method_name)
      begin
        return wrapped_method_without_block_implementation(method_name) if method_name.to_s =~ SPECIAL_METHOD_REGEX
        decl = []
        decl << %q{alias_method :WRAPPER_METHOD_NAME, :METHOD_NAME}
        decl << %q{def METHOD_NAME(*args,&block)}
        decl = decl.join("\n")
        body = %q{    (block.class.to_s == 'Proc') ? WRAPPER_METHOD_NAME(*args,&block) : WRAPPER_METHOD_NAME(*args)}
        generated_method_implementation(method_name,decl,body,"end")
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def wrapped_method_without_block_implementation(method_name)
      begin
        decl = []
        decl << %q{alias_method :WRAPPER_METHOD_NAME, :METHOD_NAME}
        decl << %q{def METHOD_NAME(value)}
        decl = decl.join("\n")
        body = %q{    self.WRAPPER_METHOD_NAME value}
        s = generated_method_implementation(method_name,decl,body,"end")
        puts s
        s
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end


    def delegated_methods(*methods,&block)
      begin
        methods.each{|method_name|
          self.class_eval delgated_method_with_block_implementation(method_name,&block)
        }
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def delgated_method_with_block_implementation(method_name,&block)
      begin
        return delgated_mutator_implementation(method_name,&block) if method_name.to_s =~ SPECIAL_METHOD_REGEX
        decl = []
        decl << %q{def METHOD_NAME(*args,&block)}
        decl = decl.join("\n")
        body = %q{    (block.class.to_s == 'Proc') ? WRAPPER_METHOD_NAME(*args,&block) : WRAPPER_METHOD_NAME(*args)}
        body = body.gsub /WRAPPER_METHOD_NAME/, block.call(method_name.to_s) + '.METHOD_NAME'
        generated_method_implementation(method_name,decl,body,"end")
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def delgated_mutator_implementation(method_name,&block)
      begin
        decl = []
        decl << %q{def METHOD_NAME(value)}
        decl = decl.join("\n")
        body = %q{    WRAPPER_METHOD_NAME value}
        body = body.gsub /WRAPPER_METHOD_NAME/, block.call(method_name.to_s) + '.METHOD_NAME'
        generated_method_implementation(method_name,decl,body,"end")
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def generated_method_implementation(method_name,method_declaration,unprotected_code,method_epilogue)
      begin
        source_code = []
        source_code << method_declaration
        source_code << "\n"
        source_code << wrapped_in_try_catch(unprotected_code)
        source_code << "\n"
        source_code << method_epilogue
        source_code << "\n"
        s = source_code.join("\n")
        s = s.chomp.gsub(Regexp.new(Regexp.escape("\n") + "+"),"\n")
        s = s.gsub(/WRAPPER_METHOD_NAME/,wrapper_method_name(method_name))
        s = s.gsub(/METHOD_NAME/,method_name.to_s)
        s
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def wrapped_in_try_catch(unprotected_code)
      begin
        protected_code = []
        protected_code << %q{   begin}
        protected_code << %q{@@IMPLEMENTATION@@}
        protected_code << %q{   rescue}
        protected_code << %q{     raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"}
        protected_code << %q{   end}
        protected_code = protected_code.join("\n")
        s = protected_code.gsub(/@@IMPLEMENTATION@@/,unprotected_code.chomp)
        s
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def predicate_methods(*method_names,&block)
      begin
        method_names.each{|name|
          self.class_eval predicate_method_implementation(name,&block)
        }
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end

    def predicate_method_implementation(method_name,&block)
      begin
        spacer = '     '
        decl = %q{def METHOD_NAME?}
        body = spacer + block.call(method_name.to_s).join("\n#{spacer}")
        s = generated_method_implementation(method_name,decl,body,"end")
        s
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end
    def named_constructors(*names,&block)
      begin
        names.each{|name|
          self.class_eval named_constructor_implementation(name,&block)
        }
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end
    def named_constructor_implementation(method_name,&block)
      begin
        decl = %q{def self.METHOD_NAME(*args)}
        body = %q{     Module.nesting[0].new} + "(#{block.call(method_name.to_s).join(',')})"
        s = generated_method_implementation(method_name,decl,body,"end")
        s
      rescue
        raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
      end
    end
  end
end
