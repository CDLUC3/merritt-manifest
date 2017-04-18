require 'spec_helper'
require 'ostruct'

module Merritt
  describe Manifest::Object do

    describe 'sample' do

      attr_reader :files
      attr_reader :manifest

      before(:each) do
        @files = [
          {
            file_url: 'http://merritt.cdlib.org/samples/4blocks.jpg',
            hash_algorithm: 'md5',
            hash_value: '0b21c6d48e815dd537d42dc1cfac0111',
            file_name: '4blocks.jpg'
          },
          {
            file_url: 'http://merritt.cdlib.org/samples/4blocks.txt',
            hash_algorithm: 'md5',
            hash_value: 'ed04a855f89f31f8dc8e9bb946f5f159',
            file_name: '4blocks.txt'
          }
        ].map { |h| OpenStruct.new(h) }
        @manifest = Manifest::Object.new(files: files)
      end

      describe :write_manifest do
        it 'writes an object manifest' do
          path = '4blocks.checkm'
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
    end
  end
end
