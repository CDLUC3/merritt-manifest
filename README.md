# Merritt Manifest Tools

This library is part of the [Merritt Preservation System](https://github.com/CDLUC3/mrt-doc).

## 

This library is not likely in active use, but it has been shared to RubyGems.

See https://rubygems.org/gems/merritt-manifest

## Purpose

A library for creating [Merritt](https://merritt.cdlib.org/) [text-based manifests](https://merritt.cdlib.org/help/manifest_guide#text_tips) (a specialization of the [Checkm](https://wiki.ucop.edu/display/Curation/Checkm) text-based manifest format).

See the [Merritt ingest service docs](https://confluence.ucop.edu/download/attachments/16744573/Merritt-ingest-service-latest.pdf)
for more information.

## Object support

Single-object manifests are supported via the `Merritt::Manifest::Object` class:

```ruby
obj_manifest = Merritt::Manifest::Object.new(
  files: [
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
)

puts obj_manifest.write_to_string
```

```text
#%checkm_0.7
#%profile | http://uc3.cdlib.org/registry/ingest/manifest/mrt-ingest-manifest
#%prefix | mrt: | http://merritt.cdlib.org/terms#
#%prefix | nfo: | http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#
#%fields | nfo:fileUrl | nfo:hashAlgorithm | nfo:hashValue | nfo:fileSize | nfo:fileLastModified | nfo:fileName | mrt:mimeType
http://merritt.cdlib.org/samples/4blocks.jpg | md5 | 0b21c6d48e815dd537d42dc1cfac0111 |  |  | 4blocks.jpg
http://merritt.cdlib.org/samples/4blocks.txt | md5 | ed04a855f89f31f8dc8e9bb946f5f159 |  |  | 4blocks.txt
#%eof
```

## Batch support

Batch manifests are not yet supported.

## DataONE Manifest support

DataONE manifests are supported via the `Merritt::Manifest::DataONE` class:

```ruby
dataone_manifest = Merritt::Manifest::DataONE.new(
  files: {
    'Laney_300394_Exempt_Determination_Letter.pdf' => 'application/pdf',
    'Laney_IRBProposal.docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'SensorSurvey_Printout.pdf' => 'application/pdf',
    'clean_survey_data_no_ids.csv' => 'text/csv',
    'research_coords.csv' => 'text/csv',
    'survey/Q10/research_sites.R' => 'text/plain',
    'survey/Q11-23/sensors_platforms.R' => 'text/plain',
    'survey/Q24/limitsToExpansion.R' => 'text/plain',
    'survey/Q25-32/data_metadata_management.R' => 'text/plain',
    'survey/Q3-9/respondent_info.R' => 'text/plain',
    'survey/Q33-37/networking.R' => 'text/plain',
    'survey/Q38-42/publications.R' => 'text/plain',
    'survey_data_prep.R' => 'text/plain'
  }.map { |name, type| OpenStruct.new(name: name, type: type) }
)

puts dataone_manifest.write_to_string
```

```text
#%dataonem_0.1
#%profile | http://uc3.cdlib.org/registry/ingest/manifest/mrt-dataone-manifest
#%prefix | dom: | http://uc3.cdlib.org/ontology/dataonem
#%prefix | mrt: | http://uc3.cdlib.org/ontology/mom
#%fields | dom:scienceMetadataFile | dom:scienceMetadataFormat | dom:scienceDataFile | mrt:mimeType
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | Laney_300394_Exempt_Determination_Letter.pdf | application/pdf
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | Laney_300394_Exempt_Determination_Letter.pdf | application/pdf
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | Laney_IRBProposal.docx | application/vnd.openxmlformats-officedocument.wordprocessingml.document
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | Laney_IRBProposal.docx | application/vnd.openxmlformats-officedocument.wordprocessingml.document
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | SensorSurvey_Printout.pdf | application/pdf
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | SensorSurvey_Printout.pdf | application/pdf
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | clean_survey_data_no_ids.csv | text/csv
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | clean_survey_data_no_ids.csv | text/csv
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | research_coords.csv | text/csv
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | research_coords.csv | text/csv
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | survey/Q10/research_sites.R | text/plain
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | survey/Q10/research_sites.R | text/plain
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | survey/Q11-23/sensors_platforms.R | text/plain
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | survey/Q11-23/sensors_platforms.R | text/plain
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | survey/Q24/limitsToExpansion.R | text/plain
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | survey/Q24/limitsToExpansion.R | text/plain
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | survey/Q25-32/data_metadata_management.R | text/plain
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | survey/Q25-32/data_metadata_management.R | text/plain
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | survey/Q3-9/respondent_info.R | text/plain
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | survey/Q3-9/respondent_info.R | text/plain
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | survey/Q33-37/networking.R | text/plain
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | survey/Q33-37/networking.R | text/plain
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | survey/Q38-42/publications.R | text/plain
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | survey/Q38-42/publications.R | text/plain
mrt-datacite.xml | http://datacite.org/schema/kernel-3.1 | survey_data_prep.R | text/plain
mrt-oaidc.xml | http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | survey_data_prep.R | text/plain
#%eof
```
