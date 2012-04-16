module CapyBrowser
  module RemoteCommunication
    class EncodedFile
      extend CapyBrowser::WrappedMethods

      attr_writer :title,:transfer_encoding
      def initialize(filename,boundry)
        raise "Unable to encode the file #{filename.inspect}" unless File.exists?(filename)
        @filename = filename
        @title = nil
        @transfer_encoding = nil
        @boundry = boundry
      end

      def content_type
        `file -Ib #{@filename}`.gsub(/\n/,"")
      end

      def title
        @title ||= File.basename(@filename)
      end

      def transfer_encoding
        @transfer_encoding ||= 'binary'
      end

      def content_length
        File.size(@filename)
      end

      def content
        File.read(@filename)
      end

      def encode(body)
        body << @boundry.to_multipart_form_delimiter
        body << %W(Content-Disposition: form-data; name="datafile"; filename="#{self.title}")
        body << %W(Content-Type: #{self.content_type})
        body << %W(Content-Transfer-Encoding: #{self.transfer_encoding})
        body << %W(Content-Length: #{self.content_length})
        body << ""
        body << self.content
        body
      end
      wrapped_methods :initialize,:content_type,
        :title,
        :transfer_encoding,
        :content_length,
        :content,
        :encode
    end
  end
end
