require 'time'
#require File.expand_path('../editorial_date', __FILE__)
#require File.expand_path('../painting', __FILE__)
#require File.expand_path('../annotation', __FILE__)

module PaintingsURI
  def paintings_uri
    begin
      URL.bbc_domain(nil,self).app_host + "/mypaintings/#{self.name}/my-collection"
    rescue
      raise "#{self.class.to_s}.paintings_uri() failed ->\n#{$!.message}"
    end
  end
  def add_painting(painting)
    begin
      [:post,self.paintings_uri,painting.to_hash]
    rescue
      raise "#{self.class.to_s}.add_painting() failed ->\n#{$!.message}"
    end
  end
  def annotate_painting(painting,annotation)
    begin
      [:post,self.paintings_uri,painting.to_hash.merge(annotation.to_hash)]
    rescue
      raise "#{self.class.to_s}.annotate_painting() failed ->\n#{$!.message}"
    end
  end
  def remove_painting(painting)
    begin
      [:delete,self.paintings_uri,painting.to_hash]
    rescue
      raise "#{self.class.to_s}.remove_painting() failed ->\n#{$!.message}"
    end
  end
end

class BasicUser
  RESERVED_ESCAPES_REGEXP = /[^#{URI::PATTERN::UNRESERVED}]/
  PERCENT_ESCAPES_REGEXP  = /((?:%[0-9a-fA-F]{2})+)/n

  include PaintingsURI

  attr_reader :passwd, :basic_auth, :basic_auth_regexp, :credentials,
    :day_of_birth, :month_of_birth, :year_of_birth

  attr_accessor :name, :firstname, :gender, :displayname,
    :uid, :email,
    :address, :country, :postcode, :town,
    :preferred_locale

  def initialize(name=nil,passwd=nil,uid=nil,token=nil)
    begin
      @token  = token  ||= Time.now.to_i
      @name   = name   ||= "yp-cuke-#{token}"
      @passwd = passwd ||= 'ypcuke'
      @uid    = uid    ||= 0xdeadbeef

      @address          = 'duncoding, easy street'
      @country          = 'Aland Islands'
      @postcode         = 'BBC Test'
      @uid              = uid
      @email            = [@name,'bbc.co.uk'].join("@")
      @preferred_locale = 'en-GB'
      @firstname        = @name
      @gender           = ""
      @town             = "Peaceful"
      @displayname      = @name

      @credentials = @name + ":" + @passwd + "@"
      @basic_auth  = URI.escape(@credentials, RESERVED_ESCAPES_REGEXP)
      @basic_auth_regexp = /(#{Regexp.escape( @basic_auth )})/i

      self.date_of_birth = EditorialDate.from_day_month_year "1/2/1971"
    rescue
      raise "#{self.class.to_s}.initialize() failed ->\n#{$!.message}"
    end
  end

  def date_of_birth=(dd_mm_yyyy)
    begin
      date = dd_mm_yyyy

      date = EditorialDate.from_day_month_year(dd_mm_yyyy) unless date.respond_to? :to_css_format

      date.to_css_format.scan(/(\d+)-(\d+)-(\d+)/){|matches|
        @day_of_birth    = matches[2].to_i
        @month_of_birth  = matches[1].to_i
        @year_of_birth   = matches[0].to_i
      }
      date
    rescue
      raise "#{self.class.to_s}.date_of_birth=() failed ->\n#{$!.message}"
    end
  end

  def to_s
    begin
      <<-EOS
        User: name  : #{self.name}
        User: pass  : #{self.passwd}
        User: email : #{self.email}
        User: uid   : #{self.uid}
        EOS
    rescue
      raise "#{self.class.to_s}.to_s() failed ->\n#{$!.message}"
    end
  end

  def to_xml
    begin
      <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<user>
<applications/>
    <details>
        <attributes>
          <address>#{self.address}</address>
          <country>#{self.country}</country>
          <postcode>#{self.postcode}</postcode>
          <id>#{self.uid}</id>
          <email>#{self.email}</email>
          <preferred_locale>#{self.preferred_locale}</preferred_locale>
          <firstname>#{self.firstname}</firstname>
          <gender>#{self.gender}</gender>
          <town>#{self.town}</town>
          <displayname>#{self.displayname}</displayname>
          <username>#{self.name}</username>
        </attributes>
    </details>
</user>
      EOS
    rescue
      raise "#{self.class.to_s}.to_xml() failed ->\n#{$!.message}"
    end
  end

  def to_query_string(attributes)
    begin
      keys   = []
      values = []

      if attributes.include? :name
        keys   << :username
        values << self.name
      end

      if attributes.include? :id
        keys   << :id
        values << self.uid
      end

      if attributes.include? :email
        keys   << :email_address
        values << self.email
      end

      if attributes.include? :passwd
        keys   << :password
        values << self.passwd
      end
      return "" if keys.empty?
      QueryString.new(keys,values).to_string
    rescue
      raise "#{self.class.to_s}.to_query_string() failed ->\n#{$!.message}"
    end
  end
end
