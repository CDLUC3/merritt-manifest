module Merritt
  class Manifest
    class DataONE < Manifest

      METADATA_FILE = 'dom:scienceMetadataFile'
      METADATA_FORMAT = 'dom:scienceMetadataFormat'
      DATA_FILE = 'dom:scienceDataFile'
      MIME_TYPE = 'mrt:mimeType'

      METADATA_FILES = {
        'mrt-datacite.xml' => 'http://datacite.org/schema/kernel-3.1',
        'mrt-oaidc.xml' => 'http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd'
      }.freeze

      # @param files [Hash{String => MIME::Type}] a map from file names ot types
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

      def to_entries(files)
        rows = files.to_a.product(METADATA_FILES.to_a).map { |p| p.flatten }
        rows.map do |file_name, file_type, md_name, md_url|
          {
            METADATA_FILE => md_name,
            METADATA_FORMAT => md_url,
            DATA_FILE => file_name,
            MIME_TYPE => file_type
          }
        end
      end
    end
  end
end
