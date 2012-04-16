require 'tempfile'
module CapyBrowser
  module RemoteCommunication
    class EncodedField
      extend CapyBrowser::WrappedMethods
      attr_reader :title,:content
      def initialize(title,content,boundry)
        @content = content
        @title   = title
        @content_type = ""
        @boundry = boundry
      end

      def content_type
        Tempfile.open("attachment"){|tf|
          tf.write(self.content)
          @content_type = EncodedFile.new(tf.path,@boundry).content_type
        }
        @content_type
      end

      def encode(body)
        body << @boundry.to_multipart_form_delimiter
        body << %W(Content-Disposition: form-data; name="#{self.title}")
        body << %W(Content-Type: #{self.content_type})
        body << ""
        body << self.content
        body
      end
      wrapped_methods :initialize,:content_type,
        :title,
        :content,
        :content_type,
        :encode
    end
  end
end
