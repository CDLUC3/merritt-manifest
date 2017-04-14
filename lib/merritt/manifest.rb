Dir.glob(File.expand_path('../manifest/*.rb', __FILE__)).sort.each(&method(:require))

module Merritt
  # A Merritt manifest file
  class Manifest

    # Base for all recognized profile URIs
    PROFILE_BASE_URI = 'http://uc3.cdlib.org/registry/ingest/manifest/'

    # @return [URI] the profile URI
    attr_reader :profile

    # @return [Hash{Symbol => URI}] a map from namespace prefixes to their URIs
    attr_reader :prefixes

    # @return [Array<String>] the field names, in the form prefix:fieldname
    attr_reader :fields

    # Creates a new manifest
    # @param profile [URI, String] the profile URI. Must begin with
    # @param prefixes: [Hash{String,Symbol => URI, String}] a map from namespace prefixes to their URIs
    # @param fields: Array<String> a list of field names, in the form prefix:fieldname
    # @raise [ArgumentError] if `profile` does not begin with {PROFILE_BASE_URI}
    # @raise [ArgumentError] if `fields` cannot be parsed as prefix:fieldname, or if one or more prefixes
    #   is not mapped to a URI in `prefixes`
    # @raise [URI::InvalidURIError] if `profile` cannot be parsed as a URI
    def initialize(profile:, prefixes: {}, fields: [])
      @profile = normalize_profile_uri(profile)
      @prefixes = normalize_prefixes(prefixes).freeze
      @fields = validate_fields(fields).freeze
    end

    private

    def validate_fields(fields)
      fields.map { |f| validate_field(f) }
    end

    def validate_field(field)
      prefix, fieldname = field.split(':')
      raise ArgumentError "Unknown prefix in field '#{field}': #{prefix}" unless prefixes.has_key?(prefix.to_sym)
      raise ArgumentError "Field '#{field}' cannot be parsed as prefix:fieldname" unless fieldname
      field
    end

    def normalize_prefixes(prefixes)
      return {} unless prefixes
      prefixes.map { |k, v| [k.to_sym, Util::to_uri(v)] }.to_h
    end

    def normalize_profile_uri(profile)
      profile_uri = Util::to_uri(profile)
      raise ArgumentError, "Invalid profile: #{profile || 'nil'}" unless profile_uri &&
        profile_uri.to_s.start_with?(PROFILE_BASE_URI)
      profile_uri
    end

  end
end
