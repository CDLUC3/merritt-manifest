module Merritt
  class Manifest
    # A specialization of {Manifest} for Merritt object submissions.
    class Object < Manifest

      # Creates a new {Manifest::Object}
      # @param files [Array<Manifest::File>] an array of data files to be converted to entries.
      #   (Note that these not be actual {Manifest::File} objects so long as they respond to,
      #   at minimum, `#file_url`. The other {Manifest::File} fields are optional.)
      def initialize(files:)
        super(
          profile: 'http://uc3.cdlib.org/registry/ingest/manifest/mrt-ingest-manifest',
          prefixes: Merritt::Manifest::Fields::Object.prefixes,
          fields: Merritt::Manifest::Fields::Object.fields,
          entries: to_entries(files)
        )
      end

      private

      def to_entries(files)
        files.map do |file|
          Merritt::Manifest::Fields::Object.map do |field|
            field_name = field.field_name
            field_value = field.value_from(file)
            [field_name, field_value]
          end.to_h
        end
      end
    end
  end
end
