require 'typesafe_enum'

module Merritt
  class Manifest

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

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def prefixes
          @prefixes ||= all_prefixes.map { |p| [p, url_for(p)] }.to_h.freeze
        end

        def fields
          @fields ||= to_a.map(&:value).freeze
        end

        def all_prefixes
          @all_prefixes ||= to_a.map(&:prefix).uniq.sort.freeze
        end

        def url_for(prefix)
          case prefix.to_sym
          when :mrt
            'http://merritt.cdlib.org/terms#'
          when :nfo
            'http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#'
          else
            raise "Unknown prefix #{prefix}"
          end
        end
      end
    end

    module Fields
      class Object < TypesafeEnum::Base
        include Field

        # @!parse FILE_URL = nfo:fileUrl
        new :FILE_URL, 'nfo:fileUrl'

        # @!parse HASH_ALGORITHM = nfo:hashAlgorithm
        new :HASH_ALGORITHM, 'nfo:hashAlgorithm'

        # @!parse HASH_VALUE = nfo:hashValue
        new :HASH_VALUE, 'nfo:hashValue'

        # @!parse FILE_SIZE = nfo:fileSize
        new :FILE_SIZE, 'nfo:fileSize'

        # @!parse FILE_LAST_MODIFIED = nfo:fileLastModified
        new :FILE_LAST_MODIFIED, 'nfo:fileLastModified'

        # @!parse FILE_NAME = nfo:fileName
        new :FILE_NAME, 'nfo:fileName'

        # @!parse MIME_TYPE = mrt:mimeType
        new :MIME_TYPE, 'mrt:mimeType'
      end
    end
  end
end
