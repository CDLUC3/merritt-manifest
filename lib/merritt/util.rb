module Merritt
  # Miscellaneous utility methods
  module Util
    class << self
      # Ensures that the specified argument is a URI.
      # @param url [String, URI] The argument. If the argument is already
      #   a URI, it is returned unchanged; otherwise, the argument's string
      #   form (as returned by +`to_s`+) is parsed as a URI.
      # @return [nil, URI] +`nil`+ if +`url`+ is nil, otherwise the URI.
      # @raise [URI::InvalidURIError] if `url` is a string that is not a valid URI
      def to_uri(url)
        return nil unless url
        return url if url.is_a? URI
        stripped = url.respond_to?(:strip) ? url.strip : url.to_s.strip
        URI.parse(stripped)
      end
    end
  end
end
