require 'merritt/manifest/fields'

module Merritt
  class Manifest
    # A marker interface for file-like objects. Each field
    # may or may not be relevant to a given manifest format.
    #
    # Some optional fields are taken from the
    # [Kernel Metadata and Electronic Resource Citations](https://tools.ietf.org/html/draft-kunze-erc-00)
    # minimal "who, what, when, and where" metadata element subset.
    #
    # Others are taken from the [Dublin Core Metadata Element Set](http://dublincore.org/documents/dces/).
    module File
      # @return [nil, URI] the URL at which to retrieve the file
      attr_reader :file_url

      # @return [nil, String] the hash algorithm used to hash the file
      attr_reader :hash_algorithm

      # @return [nil, String] the hash value
      attr_reader :hash_value

      # @return [nil, Integer] the file size in bytes
      attr_reader :file_size

      # @return [nil, DateTime] date and time the file was last modified.
      #   Note that according to the [Merritt Ingest Service docs](https://confluence.ucop.edu/download/attachments/16744573/Merritt-ingest-service-latest.pdf),
      #   “modification time field SHOULD NOT be specified, and will be ignored if provided.”
      attr_reader :file_last_modified

      # @return [nil, String] the file name. If not present, will be inferred from
      #   {#file_url}.
      attr_reader :file_name

      # @return [nil, MIME::Type] the mime type
      attr_reader :mime_type
    end

    # TODO: sort out different kinds of batches
    # module BatchFile
    #   include File
    #   # @return [nil, String] object ARK identifier. In general, the object primary identifier is left unspecified to indicate that a new object is being
    #   #   submitted (a unique primary identifier will be minted automatically during Ingest processing); the
    #   #   primary identifier is specified to indicate that a new version of a pre-existing object is being submitted
    #   attr_reader :primary_identifier
    #
    #   # @return [nil, String] a local identifier; locally-meaningful alternative object identifier,
    #   #   ERC "where" information. If an object is associated with a
    #   #   local identifier, a new version can be submitted with only a local identifier specified; the Storage
    #   #   service maintains a mapping between object primary and local identifiers that is used by the Ingest
    #   #   service to retrieve the object primary identifier while processing the submission.
    #   attr_reader :local_identifier
    #
    #   # @return [nil, String] the creator; ERC "who" information
    #   attr_reader :creator
    #
    #   # @return [nil, String] the title; ERC "what" information
    #   attr_reader :title
    #
    #   # @return [nil, String] the date; ERC "when" information
    #   attr_reader :date
    #
    #   # @return [nil, String] `dc:contributor`, an individual, corporate, or automated agent contributing to the object.
    #   attr_reader :contributor
    #
    #   # @return [nil, String] `dc:coverage`, a spatial or temporal topic or statement of applicability of jurisdiction
    #   attr_reader :coverage
    #
    #   # @return [nil, String] `dc:description`, an account of the object
    #   attr_reader :description
    #
    #   # @return [nil, String] `dc:format`, the format, medium, or dimensions of the object
    #   attr_reader :format
    #
    #   # @return [nil, String] `dc:language`, a language used by the object
    #   attr_reader :language
    #
    #   # @return [nil, String] `dc:publisher`, an individual or corporate agent publishing the object
    #   attr_reader :publisher
    #
    #   # @return [nil, String] `dc:relation`, a related resource
    #   attr_reader :relation
    #
    #   # @return [nil, String] `dc:rights`, a statement of intellectual property rights held in or over the object
    #   attr_reader :rights
    #
    #   # @return [nil, String] `dc:source`, a related resource from which the
    #   #   object is derived.
    #   attr_reader :source
    #
    #   # @return [nil, String] `dc:subject`, the topic of the object
    #   attr_reader :subject
    #
    #   # @return [nil, String] `dc:type`, the nature or genre of the object.
    #   attr_reader :type
    #
    #   # @return [nil, String] the DataCite resource type (general)
    #   attr_reader :resource_type
    # end
  end
end
