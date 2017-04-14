Dir.glob(File.expand_path('../manifest/*.rb', __FILE__)).sort.each(&method(:require))

module Merritt
  class Manifest

    attr_reader :profile

    def initialize(profile:)
      @profile = valid_profile_uri(profile)
    end

    private

    def valid_profile_uri(profile)
      profile_uri = to_uri(profile)
      raise ArgumentError, "Invalid profile: #{profile || 'nil'}" unless profile_uri &&
        profile_uri.to_s.start_with?('http://uc3.cdlib.org/registry/ingest/manifest/')
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
