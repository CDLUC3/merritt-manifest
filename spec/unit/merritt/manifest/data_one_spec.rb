require 'spec_helper'
require 'ostruct'

module Merritt
  describe Manifest::DataONE do
    attr_reader :files
    attr_reader :manifest

    before(:each) do
      @files = {
        'Laney_300394_Exempt_Determination_Letter.pdf' => 'application/pdf',
        'Laney_IRBProposal.docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'SensorSurvey_Printout.pdf' => 'application/pdf',
        'clean_survey_data_no_ids.csv' => 'text/csv',
        'research_coords.csv' => 'text/csv',
        'survey/Q10/research_sites.R' => 'text/plain',
        'survey/Q11-23/sensors_platforms.R' => 'text/plain',
        'survey/Q24/limitsToExpansion.R' => 'text/plain',
        'survey/Q25-32/data_metadata_management.R' => 'text/plain',
        'survey/Q3-9/respondent_info.R' => 'text/plain',
        'survey/Q33-37/networking.R' => 'text/plain',
        'survey/Q38-42/publications.R' => 'text/plain',
        'survey_data_prep.R' => 'text/plain'
      }.map { |name, type| OpenStruct.new(file_name: name, mime_type: type) }
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
        files.each_with_index do |file, index|
          dcs_index = 2 * index
          dcs_entry = entries[dcs_index]
          oai_entry = entries[1 + dcs_index]
          expect(dcs_entry['dom:scienceMetadataFile']).to eq('mrt-datacite.xml')
          expect(oai_entry['dom:scienceMetadataFile']).to eq('mrt-oaidc.xml')
          expect(dcs_entry['dom:scienceMetadataFormat']).to eq('http://datacite.org/schema/kernel-3.1')
          expect(oai_entry['dom:scienceMetadataFormat']).to eq('http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd')

          [dcs_entry, oai_entry].each do |entry|
            expect(entry['dom:scienceDataFile']).to eq(file.file_name)
            expect(entry['mrt:mimeType']).to eq(file.mime_type)
          end
        end
      end
    end

    describe :write_to_string do
      it 'writes a DataONE manifest' do
        path = 'mrt-dataone-manifest.txt'
        expected = File.read("spec/data/#{path}")
        actual = manifest.write_to_string
        if actual != expected
          now = Time.now.to_i
          FileUtils.mkdir('tmp') unless File.directory?('tmp')
          File.open("tmp/#{now}-expected-#{path}", 'w') { |f| f.write(expected) }
          File.open("tmp/#{now}-actual-#{path}", 'w') { |f| f.write(actual) }
        end
        expect(actual).to eq(expected)
      end
    end

    describe :write_to_file do
      it 'writes to a file' do
        file = Tempfile.new('manifest.txt')
        begin
          manifest.write_to(file)
          file.close
          actual = IO.read(file.path)
          path = 'mrt-dataone-manifest.txt'
          expected = File.read("spec/data/#{path}")
          actual = manifest.write_to_string
          if actual != expected
            now = Time.now.to_i
            FileUtils.mkdir('tmp') unless File.directory?('tmp')
            File.open("tmp/#{now}-expected-#{path}", 'w') { |f| f.write(expected) }
            File.open("tmp/#{now}-actual-#{path}", 'w') { |f| f.write(actual) }
          end
        ensure
          file.delete
        end
      end
    end
  end
end
