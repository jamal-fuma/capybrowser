module CapyBrowser
  module RemoteCommunication
    class MultipartForm
      extend CapyBrowser::WrappedMethods
      def initialize(entities)
        raise "no entities provided to attach" if entities.empty?
        @boundry = MultipartFormBoundry.new
        @entities = entities
      end

      def encode(request)
        request.set_content_type self.content_type
        request.body = self.content
        request
      end

      def content_type
        @boundry.to_multipart_form_content_type
      end

      def content
        body = []
        @entities.each{|name,value|
          attachment = nil
          attachment ||= EncodedFile.new(value,@boundry) rescue nil
          attachment ||= EncodedField.new(name,value,@boundry)
          body = attachment.encode(body)
        }
        @boundry.to_multipart_form(body)
      end
      wrapped_methods :initialize, :content, :content_type, :encode
    end
  end
end
