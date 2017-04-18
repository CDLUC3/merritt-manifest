require 'merritt/manifest/fields'

module Merritt
  class Manifest
    # A marker interface for file-like objects. Each field
    # may or may not be relevant to a given manifest format.
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
  end
end
