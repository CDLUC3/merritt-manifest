require 'merritt/manifest/fields'

module Merritt
  class Manifest
    # A specialization of {Manifest} for DataONE.
    class DataONE < Manifest

      # Creates a new {Manifest::DataONE}
      # @param files [Array<Manifest::File>] an array of data files to be converted to entries.
      #   (Note that these not be actual {Manifest::File} objects so long as they respond to
      #   `#file_name` and `#mime_type`)
      def initialize(files:)
        super(
          conformance: 'dataonem_0.1',
          profile: 'http://uc3.cdlib.org/registry/ingest/manifest/mrt-dataone-manifest',
          prefixes: {
            dom: 'http://uc3.cdlib.org/ontology/dataonem',
            mrt: 'http://uc3.cdlib.org/ontology/mom'
          },
          fields: [METADATA_FILE, METADATA_FORMAT, DATA_FILE, MIME_TYPE],
          entries: to_entries(files)
        )
      end

      private

      METADATA_FILE = 'dom:scienceMetadataFile'.freeze
      METADATA_FORMAT = 'dom:scienceMetadataFormat'.freeze
      DATA_FILE = 'dom:scienceDataFile'.freeze
      MIME_TYPE = 'mrt:mimeType'.freeze

      METADATA_FILES = {
        'mrt-datacite.xml' => 'http://datacite.org/schema/kernel-4',
        'mrt-oaidc.xml' => 'http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd'
      }.freeze

      def to_entries(files)
        rows = files.product(METADATA_FILES.to_a).map(&:flatten)
        rows.map do |file, md_name, md_url|
          {
            METADATA_FILE => md_name,
            METADATA_FORMAT => md_url,
            DATA_FILE => file.file_name,
            MIME_TYPE => Merritt::Manifest::Fields::Object::MIME_TYPE.value_from(file)
          }
        end
      end
    end
  end
end
