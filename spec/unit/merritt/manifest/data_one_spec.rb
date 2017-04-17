require 'spec_helper'

module Merritt
  describe Manifest::DataONE do
    attr_reader :files
    attr_reader :manifest

    before(:each) do
      @files = {
        'survey/Q11-23/sensors_platforms.R' => 'text/plain',
        'survey/Q25-32/data_metadata_management.R' => 'text/plain',
        'survey/Q10/research_sites.R' => 'text/plain',
        'clean_survey_data_no_ids.csv' => 'text/csv',
        'survey/Q3-9/respondent_info.R' => 'text/plain',
        'Laney_IRBProposal.docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'survey_data_prep.R' => 'text/plain',
        'research_coords.csv' => 'text/csv',
        'Laney_300394_Exempt_Determination_Letter.pdf' => 'application/pdf',
        'survey/Q33-37/networking.R' => 'text/plain',
        'SensorSurvey_Printout.pdf' => 'application/pdf',
        'survey/Q24/limitsToExpansion.R' => 'text/plain',
        'survey/Q38-42/publications.R' => 'text/plain'
      }
      @manifest = Manifest::DataONE.new(files: files)
    end

    describe :conformance do
      it 'returns DataONE 0.1' do
        expect(manifest.conformance).to eq('dataonem_0.1')
      end
    end

    describe :profile do
      it 'returns the DataONE manifest profile' do
        expect(manifest.profile).to eq(URI('http://uc3.cdlib.org/registry/ingest/manifest/mrt-dataone-manifest'))
      end
    end

    describe :prefixes do
      attr_reader :prefixes
      before(:each) do
        @prefixes = manifest.prefixes
      end
      it 'includes :dom' do
        expect(prefixes[:dom]).to eq(URI('http://uc3.cdlib.org/ontology/dataonem'))
      end
      it 'includes :mrt' do
        expect(prefixes[:mrt]).to eq(URI('http://uc3.cdlib.org/ontology/mom'))
      end
    end

    describe :fields do
      it 'returns the expected fields' do
        expected = %w[dom:scienceMetadataFile dom:scienceMetadataFormat dom:scienceDataFile mrt:mimeType]
        expect(manifest.fields).to eq(expected)
      end
    end

    describe :entries do
      attr_reader :entries
      before(:each) do
        @entries = manifest.entries
      end

      it 'converts files to entries' do
        expect(entries.size).to eq(2 * files.size)
        files.to_a.each_with_index do |file, index|
          file_name, file_type = file

          dcs_index = 2 * index
          dcs_entry = entries[dcs_index]
          oai_entry = entries[1 + dcs_index]
          expect(dcs_entry['dom:scienceMetadataFile']).to eq('mrt-datacite.xml')
          expect(oai_entry['dom:scienceMetadataFile']).to eq('mrt-oaidc.xml')
          expect(dcs_entry['dom:scienceMetadataFormat']).to eq('http://datacite.org/schema/kernel-3.1')
          expect(oai_entry['dom:scienceMetadataFormat']).to eq('http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd')

          [dcs_entry, oai_entry].each do |entry|
            expect(entry['dom:scienceDataFile']).to eq(file_name)
            expect(entry['mrt:mimeType']).to eq(file_type)
          end
        end
      end
    end
  end
end
