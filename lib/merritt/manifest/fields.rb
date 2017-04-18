require 'typesafe_enum'
require 'uri'

module Merritt
  class Manifest

    # Mixin for field enumerations
    module Field
      # Gets the reader method for this field
      def reader
        @reader ||= key.downcase
      end

      # Reads the value of this field from the specified object, if available
      def value_from(obj)
        return unless obj.respond_to?(reader)
        obj.send(reader)
      end

      # @return [String] the fieldname
      def field_name
        value
      end

      # The prefix for this field
      def prefix
        @prefix ||= begin
          prefix, name = value.split(':')
          prefix if name # if we didn't find a name, then there's no ':' and hence no prefix
        end
      end

      # Implemented to inject {ClassMethods} into field enumerations that include this module
      def self.included(base)
        base.extend(ClassMethods)
      end

      # Class methods for field enumerations
      module ClassMethods
        # Gets all prefixes in these fields, and their URLs
        # @return [Hash<Symbol, String>] all prefixes used by these fields, as a map from symbol to URL string
        def prefixes
          @prefixes ||= begin
            all_prefixes = to_a.map(&:prefix).uniq.sort.freeze
            all_prefixes.map { |p| [p, url_for(p)] }.to_h.freeze
          end
        end

        # A list of all fields
        # @return [String] a list of all fields, as (prefix-qualified) names
        def fields
          @fields ||= to_a.map(&:value).freeze
        end

        # Gets the string for the specified prefix
        # @param prefix [String, Symbol] the prefix
        # @return [String] the URL string for the prefix
        def url_for(prefix)
          # noinspection RubyCaseWithoutElseBlockInspection
          case prefix.to_sym
          when :mrt
            'http://merritt.cdlib.org/terms#'
          when :nfo
            'http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#'
          end
        end
      end
    end

    # Holder module for field enumerations
    module Fields
      # Enumeration of fields for object manifests
      class Object < TypesafeEnum::Base
        include Field
        # @!parse extend Merritt::Manifest::Field::ClassMethods

        # Field for `nfo:fileUrl`. Parses string URLs as URI objects.
        new(:FILE_URL, 'nfo:fileUrl') do
          def value_from(obj)
            value = super(obj)
            raise ArgumentError, "No :#{reader} method provided for #{obj}" unless value
            Merritt::Util.to_uri(value)
          end
        end

        # field for `nfo:hashAlgorithm`
        new :HASH_ALGORITHM, 'nfo:hashAlgorithm'

        # field for `nfo:hashValue`
        new :HASH_VALUE, 'nfo:hashValue'

        # field for `nfo:fileSize`. Parses string values as integers.
        new :FILE_SIZE, 'nfo:fileSize' do
          def value_from(obj)
            value = super(obj)
            return unless value
            value.to_i
          end
        end

        # field for `nfo:fileLastModified`
        new :FILE_LAST_MODIFIED, 'nfo:fileLastModified'

        # field for `nfo:fileName`. If no file name is provided, parses it from {FILE_URL}.
        new :FILE_NAME, 'nfo:fileName' do
          def value_from(obj)
            value = super(obj)
            return value if value
            file_url = FILE_URL.value_from(obj)
            URI(file_url).path.split('/').last
          end
        end

        # field for `mrt:mimeType`
        new :MIME_TYPE, 'mrt:mimeType'
      end
    end
  end
end
