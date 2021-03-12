# Reverts https://github.com/crystal-lang/crystal/pull/10485

module HTTP
  class Cookie
    def initialize(name : String, value : String, @path : String = "/",
                   @expires : Time? = nil, @domain : String? = nil,
                   @secure : Bool = false, @http_only : Bool = false,
                   @samesite : SameSite? = nil, @extension : String? = nil)
      @name = name
      @value = value
    end

    def name=(name : String)
      @name = name
    end

    def value=(value : String)
      @value = value
    end

    def to_cookie_header(io)
      io << @name
      io << '='
      URI.encode_www_form(value, io)
    end

    module Parser
      def parse_cookies(header)
        header.scan(CookieString).each do |pair|
          yield Cookie.new(pair["name"], URI.decode_www_form(pair["value"]))
        end
      end

      def parse_set_cookie(header)
        match = header.match(SetCookieString)
        return unless match
        expires = if max_age = match["max_age"]?
                    Time.utc + max_age.to_i64.seconds
                  else
                    parse_time(match["expires"]?)
                  end

        Cookie.new(
          URI.decode_www_form(match["name"]), URI.decode_www_form(match["value"]),
          path: match["path"]? || "/",
          expires: expires,
          domain: match["domain"]?,
          secure: match["secure"]? != nil,
          http_only: match["http_only"]? != nil,
          samesite: match["samesite"]?.try { |v| SameSite.parse? v },
          extension: match["extension"]?
        )
      end
    end
  end
end
