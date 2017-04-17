require 'spec_helper'

module Merritt
  describe Manifest do

    attr_reader :dataone_profile

    before(:each) do
      @dataone_profile = 'http://uc3.cdlib.org/registry/ingest/manifest/mrt-dataone-manifest'
    end

    describe :new do
      it 'creates a new manifest' do
        manifest = Manifest.new(profile: dataone_profile)
        expect(manifest).to be_a(Manifest)
      end

      describe :conformance do
        it 'defaults to CheckM 0.7' do
          manifest = Manifest.new(profile: dataone_profile)
          expect(manifest.conformance).to eq('checkm_0.7')
        end
      end

      describe :profile do
        it 'accepts a string' do
          profile_str = dataone_profile
          manifest = Manifest.new(profile: profile_str)
          expect(manifest.profile).to eq(URI.parse(profile_str))
        end

        it 'accepts a URI' do
          profile = URI.parse(dataone_profile)
          manifest = Manifest.new(profile: profile)
          expect(manifest.profile).to eq(profile)
        end

        it 'requires a profile' do
          expect { Manifest.new }.to raise_error(ArgumentError)
        end

        it 'requires profile to be a URL' do
          expect { Manifest.new(profile: 'elvis') }.to raise_error(ArgumentError)
        end

        it 'requires a Merritt manifest profile' do
          profile = 'http://example.org/my-profile'
          expect { Manifest.new(profile: profile) }.to raise_error(ArgumentError)
        end
      end

      describe :prefixes do
        it 'defaults to empty' do
          manifest = Manifest.new(profile: dataone_profile)
          prefixes = manifest.prefixes
          expect(prefixes).to be_a(Hash)
          expect(prefixes).to be_empty
        end

        it 'normalizes keys to symbols and values to URIs' do
          in_prefixes = {
            :mrt => URI('http://merritt.cdlib.org/terms#'),
            'dom' => 'http://uc3.cdlib.org/ontology/dataonem',
            :nfo => 'http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#'
          }
          manifest = Manifest.new(profile: dataone_profile, prefixes: in_prefixes)
          out_prefixes = manifest.prefixes
          expect(out_prefixes.size).to eq(in_prefixes.size)
          expect(out_prefixes[:mrt]).to eq(in_prefixes[:mrt])
          expect(out_prefixes[:dom]).to eq(URI(in_prefixes['dom']))
          expect(out_prefixes[:nfo]).to eq(URI(in_prefixes[:nfo]))
        end
      end

      describe :fields do
        it 'defaults to empty' do
          manifest = Manifest.new(profile: dataone_profile)
          fields = manifest.fields
          expect(fields).to be_an(Array)
          expect(fields).to be_empty
        end

        it 'accepts a list of fields' do
          in_fields = %w[dom:scienceMetadataFile dom:scienceMetadataFormat dom:scienceDataFile mrt:mimeType]
          manifest = Manifest.new(
            profile: dataone_profile,
            fields: in_fields,
            prefixes: {
              mrt: 'http://merritt.cdlib.org/terms#',
              dom: 'http://uc3.cdlib.org/ontology/dataonem'
            }
          )
          out_fields = manifest.fields
          expect(out_fields.size).to eq(in_fields.size)
          expect(out_fields).to eq(in_fields)
          expect(out_fields).not_to be(in_fields)
        end
      end

      describe :entries do
        it 'accepts a list of entries' do

          in_entries = [
            {
              'dom:scienceMetadataFile' => 'mrt-datacite.xml',
              'dom:scienceMetadataFormat' => 'http://datacite.org/schema/kernel-3.1',
              'dom:scienceDataFile' => 'Laney_300394_Exempt_Determination_Letter.pdf',
              'mrt:mimeType' => 'application/pdf'
            },
            {
              'dom:scienceMetadataFile' => 'mrt-oaidc.xml',
              'dom:scienceMetadataFormat' => 'http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd',
              'dom:scienceDataFile' => 'Laney_300394_Exempt_Determination_Letter.pdf',
              'mrt:mimeType' => 'application/pdf'
            }
          ]

          manifest = Manifest.new(
            profile: dataone_profile,
            fields: %w[dom:scienceMetadataFile dom:scienceMetadataFormat dom:scienceDataFile mrt:mimeType],
            prefixes: {
              mrt: 'http://merritt.cdlib.org/terms#',
              dom: 'http://uc3.cdlib.org/ontology/dataonem'
            },
            entries: in_entries
          )

          out_entries = manifest.entries
          expect(out_entries).to eq(in_entries)
        end
      end
    end
  end
end
