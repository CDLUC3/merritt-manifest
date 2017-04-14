require 'spec_helper'

module Merritt
  describe Manifest do

    describe :new do
      it 'creates a new manifest' do
        manifest = Manifest.new(profile: 'http://uc3.cdlib.org/registry/ingest/manifest/mrt-dataone-manifest')
        expect(manifest).to be_a(Manifest)
      end

      describe :profile do
        it 'accepts a string' do
          profile_str = 'http://uc3.cdlib.org/registry/ingest/manifest/mrt-dataone-manifest'
          manifest = Manifest.new(profile: profile_str)
          expect(manifest.profile).to eq(URI.parse(profile_str))
        end

        it 'accepts a URI' do
          profile = URI.parse('http://uc3.cdlib.org/registry/ingest/manifest/mrt-dataone-manifest')
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

    end
  end
end
