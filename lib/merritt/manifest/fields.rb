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

      # TODO: sort out different kinds of batches
      # module Batch
      #   # "Required" fields. A column for each of these fields is always present, even if empty
      #   class Required < TypesafeEnum::Base
      #     include Field
      #
      #     # @!parse FILE_URL = nfo:fileUrl
      #     new :FILE_URL, 'nfo:fileUrl'
      #
      #     # @!parse HASH_ALGORITHM = nfo:hashAlgorithm
      #     new :HASH_ALGORITHM, 'nfo:hashAlgorithm'
      #
      #     # @!parse HASH_VALUE = nfo:hashValue
      #     new :HASH_VALUE, 'nfo:hashValue'
      #
      #     # @!parse FILE_SIZE = nfo:fileSize
      #     new :FILE_SIZE, 'nfo:fileSize'
      #
      #     # @!parse FILE_LAST_MODIFIED = nfo:fileLastModified
      #     new :FILE_LAST_MODIFIED, 'nfo:fileLastModified'
      #
      #     # @!parse FILE_NAME = nfo:fileName
      #     new :FILE_NAME, 'nfo:fileName'
      #
      #     # @!parse PRIMARY_IDENTIFIER = mrt:primaryIdentifier
      #     new :PRIMARY_IDENTIFIER, 'mrt:primaryIdentifier'
      #
      #     # @!parse LOCAL_IDENTIFIER = mrt:localIdentifier
      #     new :LOCAL_IDENTIFIER, 'mrt:localIdentifier'
      #
      #     # @!parse CREATOR = mrt:creator
      #     new :CREATOR, 'mrt:creator'
      #
      #     # @!parse TITLE = mrt:title
      #     new :TITLE, 'mrt:title'
      #
      #     # @!parse DATE = mrt:date
      #     new :DATE, 'mrt:date'
      #   end
      #
      #   #"Optional" fields. If any entry has one of these fields, then a column for that field
      #   # will be present -- along with (potentially empty) columns for each field to its left.
      #   class Optional < TypesafeEnum::Base
      #
      #     # @!parse CONTRIBUTOR = mrt:contributor
      #     new :CONTRIBUTOR, 'mrt:contributor'
      #
      #     # @!parse COVERAGE = mrt:coverage
      #     new :COVERAGE, 'mrt:coverage'
      #
      #     # @!parse DESCRIPTION = mrt:description
      #     new :DESCRIPTION, 'mrt:description'
      #
      #     # @!parse FORMAT = mrt:format
      #     new :FORMAT, 'mrt:format'
      #
      #     # @!parse LANGUAGE = mrt:language
      #     new :LANGUAGE, 'mrt:language'
      #
      #     # @!parse PUBLISHER = mrt:publisher
      #     new :PUBLISHER, 'mrt:publisher'
      #
      #     # @!parse RELATION = mrt:relation
      #     new :RELATION, 'mrt:relation'
      #
      #     # @!parse RIGHTS = mrt:rights
      #     new :RIGHTS, 'mrt:rights'
      #
      #     # @!parse SOURCE = mrt:source
      #     new :SOURCE, 'mrt:source'
      #
      #     # @!parse SUBJECT = mrt:subject
      #     new :SUBJECT, 'mrt:subject'
      #
      #     # @!parse TYPE = mrt:type
      #     new :TYPE, 'mrt:type'
      #
      #     # @!parse RESOURCE_TYPE = mrt:resourceType
      #     new :RESOURCE_TYPE, 'mrt:resourceType'
      #   end
      # end

    end
  end
end
