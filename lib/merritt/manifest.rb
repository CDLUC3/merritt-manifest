Dir.glob(File.expand_path('../manifest/*.rb', __FILE__)).sort.each(&method(:require))

module Merritt
  # A Merritt manifest file
  class Manifest

    # Base for all recognized profile URIs
    PROFILE_BASE_URI = 'http://uc3.cdlib.org/registry/ingest/manifest/'

    # @return [URI] the profile URI
    attr_reader :profile

    # Creates a new manifest
    # @param profile [URI, String] the profile URI. Must begin with
    # @raise [ArgumentError] if `profile` does not begin with {PROFILE_BASE_URI}
    # @raise [URI::InvalidURIError] if `profile` cannot be parsed as a URI
    def initialize(profile:)
      @profile = valid_profile_uri(profile)
    end

    private

    def valid_profile_uri(profile)
      profile_uri = to_uri(profile)
      raise ArgumentError, "Invalid profile: #{profile || 'nil'}" unless profile_uri &&
        profile_uri.to_s.start_with?(PROFILE_BASE_URI)
      profile_uri
    end

    def to_uri(url)
      return nil unless url
      return url if url.is_a? URI
      stripped = url.respond_to?(:strip) ? url.strip : url.to_s.strip
      URI.parse(stripped)
    end
  end
end
