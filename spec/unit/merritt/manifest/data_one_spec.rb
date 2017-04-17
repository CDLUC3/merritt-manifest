require 'spec_helper'

module Merritt
  describe Manifest::DataONE do
    attr_reader :files

    before(:each) do
      @files = {
        'survey/Q11-23/sensors_platforms.R' => 'text/plain',
        'survey/Q25-32/data_metadata_management.R' => 'text/plain',
        'survey/Q10/research_sites.R' => 'text/plain',
        'clean_survey_data_no_ids.csv' => 'text/csv',
        'survey/Q3-9/respondent_info.R' => 'text/plain',
        'Laney_IRBProposal.docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'survey_data_prep.R' => 'text/plain',
        'research_coords.csv' => 'text/csv',
        'Laney_300394_Exempt_Determination_Letter.pdf' => 'application/pdf',
        'survey/Q33-37/networking.R' => 'text/plain',
        'SensorSurvey_Printout.pdf' => 'application/pdf',
        'survey/Q24/limitsToExpansion.R' => 'text/plain',
        'survey/Q38-42/publications.R' => 'text/plain',
      }
    end

    describe :initialize do
      attr_reader :manifest
      before(:each) do
        @manifest = Manifest::DataONE.new(files: files)
      end
      it 'sets the conformance' do
        expect(manifest.conformance).to eq('dataonem_0.1')
      end
    end
  end
end
