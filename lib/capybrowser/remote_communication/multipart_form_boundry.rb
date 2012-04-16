module CapyBrowser
  module RemoteCommunication
    class MultipartFormBoundry
     extend CapyBrowser::WrappedMethods

      attr_reader :delimiter,:prefix
      def initialize
        time   = Time.now.to_f
        random = Kernel.rand(time).to_s
        @seed   = random.unpack("C*").inject(0){|sum,byte| sum + (byte * 0x33) }
        @prefix = "0123456789ABLEWASIEREISAWELBA9876543210"
        @delimiter = generate(@seed,@prefix)
      end

      def generate(seed,prefix)
        sum  = 0
        boundry = prefix.unpack("C*").map{|byte|
          sum  += (byte ^ (seed))
          seed += (byte * 0x33)
          [sum & 0xFF].pack("C*")
        }
        "#{prefix}#{[boundry.join("")].pack("m*")}"
      end

      def to_multipart_form_content_type
        "multipart/form-data, boundary=#{@delimiter}"
      end

      def to_multipart_form_delimiter
        "--#{@delimiter}"
      end

      def to_multipart_form(body)
        "#{body.join("\r\n")}\r\n--#{@delimiter}--\r\n"
      end

      wrapped_methods :initialize, :generate,
        :to_multipart_form_content_type,
        :to_multipart_form_delimiter,
        :to_multipart_form
    end
  end
end
