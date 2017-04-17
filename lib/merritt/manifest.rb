Dir.glob(File.expand_path('../manifest/*.rb', __FILE__)).sort.each(&method(:require))

module Merritt
  # A Merritt manifest file
  class Manifest

    # Base for all recognized profile URIs
    PROFILE_BASE_URI = 'http://uc3.cdlib.org/registry/ingest/manifest/'.freeze

    # Checkm 0.7 conformance level
    CHECKM_0_7 = 'checkm_0.7'.freeze

    # @return [String] the conformance level
    attr_reader :conformance

    # @return [URI] the profile URI
    attr_reader :profile

    # @return [Hash{Symbol => URI}] a map from namespace prefixes to their URIs
    attr_reader :prefixes

    # @return [Array<String>] the field names, in the form prefix:fieldname
    attr_reader :fields

    # @return [Array<Hash<String, Object>>] the entries
    attr_reader :entries

    # Creates a new manifest. Note that the prefix, field, and entry arrays are
    # copied on initialization, as are the individual entry hashes.
    #
    # @param conformance [String] the conformance level. Defaults to {CHECKM_0_7}.
    # @param profile [URI, String] the profile URI. Must begin with
    # @param prefixes [Hash{String,Symbol => URI, String}] a map from namespace prefixes to their URIs
    # @param fields Array<String> a list of field names, in the form prefix:fieldname
    # @param entries [Array<Hash<String, Object><] A list of entries, each of which is a hash keyed by
    #   a prefixed fieldname defined in `fields`. Nil values are allowed.
    # @raise [ArgumentError] if `profile` does not begin with {PROFILE_BASE_URI}
    # @raise [ArgumentError] if `fields` cannot be parsed as prefix:fieldname, or if one or more prefixes
    #   is not mapped to a URI in `prefixes`
    # @raise [URI::InvalidURIError] if `profile` cannot be parsed as a URI
    def initialize(conformance: CHECKM_0_7, profile:, prefixes: {}, fields: [], entries: [])
      @conformance = conformance
      @profile = normalize_profile_uri(profile).freeze
      @prefixes = normalize_prefixes(prefixes).freeze
      @fields = validate_fields(fields).freeze
      @entries = normalize_entries(entries).freeze
    end

    private

    def normalize_entries(entries)
      entries.each_with_index.map do |entry, i|
        raise ArgumentError, "Nil entry at index #{i}" unless entry
        normalize_entry(entry)
      end
    end

    def normalize_entry(entry)
      normalized = {}
      fields.each do |f|
        next unless (value = entry[f])
        normalized[f] = value
      end
      raise ArgumentError, "No fields found in entry #{entry}" if normalized.empty?
      normalized
    end

    def validate_fields(fields)
      fields.map { |f| validate_field(f) }
    end

    def validate_field(field)
      prefix, fieldname = field.split(':')
      raise ArgumentError "Unknown prefix in field '#{field}': #{prefix}" unless prefixes.key?(prefix.to_sym)
      raise ArgumentError "Field '#{field}' cannot be parsed as prefix:fieldname" unless fieldname
      field
    end

    def normalize_prefixes(prefixes)
      return {} unless prefixes
      prefixes.map { |k, v| [k.to_sym, Util.to_uri(v)] }.to_h
    end

    def normalize_profile_uri(profile)
      profile_uri = Util.to_uri(profile)
      raise ArgumentError, "Invalid profile: #{profile || 'nil'}" unless profile_uri &&
        profile_uri.to_s.start_with?(PROFILE_BASE_URI)
      profile_uri.clone # defensive copy
    end

  end
end
