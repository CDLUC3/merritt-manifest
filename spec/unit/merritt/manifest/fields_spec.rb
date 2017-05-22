require 'spec_helper'
require 'ostruct'

module Merritt
  describe Manifest::Fields::Object do
    describe :value_from do
      describe :FILE_URL do
        it 'returns a URI even if given a String' do
          url_str = 'http://example.org/example.txt'
          obj = OpenStruct.new(file_url: url_str)
          expected = URI(url_str)
          actual = Manifest::Fields::Object::FILE_URL.value_from(obj)
          expect(actual).to eq(expected)
        end

        it 'fails if not present' do
          obj = OpenStruct.new
          expect { Manifest::Fields::Object::FILE_URL.value_from(obj) }.to raise_error(ArgumentError)
        end
      end

      describe :FILE_SIZE do
        it 'returns nil for nil' do
          obj = OpenStruct.new
          actual = Manifest::Fields::Object::FILE_SIZE.value_from(obj)
          expect(actual).to be_nil
        end
        it 'returns an integer even if given a String' do
          obj = OpenStruct.new(file_size: '1234')
          expected = 1234
          actual = Manifest::Fields::Object::FILE_SIZE.value_from(obj)
          expect(actual).to eq(expected)
        end
      end

      describe :FILE_NAME do
        it 'prefers the filename to the URI' do
          url = URI('http://example.org/example.txt')
          name = 'EXAMPLE.TXT'
          obj = OpenStruct.new(file_url: url, file_name: name)
          actual = Manifest::Fields::Object::FILE_NAME.value_from(obj)
          expect(actual).to eq(name)
        end

        it 'extracts the filename from the URI if not present' do
          url = URI('http://example.org/example.txt')
          obj = OpenStruct.new(file_url: url)
          expected = 'example.txt'
          actual = Manifest::Fields::Object::FILE_NAME.value_from(obj)
          expect(actual).to eq(expected)
        end
      end

      describe :MIME_TYPE do
        it 'extracts the mime type' do
          mime_type = 'text/html'
          obj = OpenStruct.new(mime_type: mime_type)
          mt_val = ::MIME::Types[mime_type].first
          expect(mt_val).not_to be_nil # just to be sure
          actual = Manifest::Fields::Object::MIME_TYPE.value_from(obj)
          expect(actual).to eq(mt_val.to_s)
        end

        it 'accepts unknown or garbage types' do
          mime_type = 'I am not a mime type, but whatever'
          obj = OpenStruct.new(mime_type: mime_type)
          mt_val = ::MIME::Types[mime_type].first
          expect(mt_val).to be_nil # just to be sure
          actual = Manifest::Fields::Object::MIME_TYPE.value_from(obj)
          expect(actual).to eq(mime_type)
        end
      end
    end
  end
end
