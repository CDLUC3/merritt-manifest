# 0.1.2 (22 April 2017)

- Fixed issue where unknown MIME types would not be written to the manifest (#1)

# 0.1.1 (18 April 2017)

- `Merritt::Manifest::Fields::Object::MIME_TYPE` now correctly parses strings as
  `MIME::Type` objects.
- **BREAKING CHANGE:** `Merritt::Manifest::DataONE` now uses the standard `file_name`
  and `mime_type` fields rather than `name` and `type`.

# 0.1.0 (18 April 2017)

- Initial release.
