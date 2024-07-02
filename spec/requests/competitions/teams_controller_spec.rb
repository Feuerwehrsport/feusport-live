# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team do
  let!(:competition) { create(:competition) }
  let!(:band) { create(:band, competition:) }
  let!(:la) { create(:discipline, :la, competition:) }
  let!(:assessment) { create(:assessment, competition:, discipline: la, band:) }
  let!(:user) { competition.users.first }

  describe 'teams managements' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/teams"
      expect(response).to match_html_fixture.with_affix('index-empty')

      get "/#{competition.year}/#{competition.slug}/teams/new?band_id=#{band.id}"
      expect(response).to match_html_fixture.with_affix('new')

      post "/#{competition.year}/#{competition.slug}/teams",
           params: { band_id: band.id, team: { name: 'new-name', shortcut: '', number: '1' } }
      expect(response).to match_html_fixture.with_affix('new-with-errors').for_status(422)

      expect do
        post "/#{competition.year}/#{competition.slug}/teams",
             params: { band_id: band.id, team: { name: 'new-name', shortcut: 'new-n', number: '1' } }
        follow_redirect!
        expect(response).to match_html_fixture.with_affix('show-empty')
      end.to change(described_class, :count).by(1)

      get "/#{competition.year}/#{competition.slug}/teams"
      expect(response).to match_html_fixture.with_affix('index-with-one')

      new_id = described_class.last.id

      get "/#{competition.year}/#{competition.slug}/teams/#{new_id}/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      patch "/#{competition.year}/#{competition.slug}/teams/#{new_id}",
            params: { team: { name: 'new-name', shortcut: '', number: '1' } }
      expect(response).to have_http_status(:unprocessable_entity)

      patch "/#{competition.year}/#{competition.slug}/teams/#{new_id}",
            params: { team: { name: 'new-name', shortcut: 'short', number: '1' } }
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/teams/#{new_id}")
      expect(described_class.find(new_id).shortcut).to eq('short')

      expect do
        delete "/#{competition.year}/#{competition.slug}/teams/#{new_id}"
      end.to change(described_class, :count).by(-1)
    end
  end

  describe 'assessment requests' do
    let!(:team) { create(:team, competition:, band:) }

    it 'can manage requests' do
      sign_in user

      tgl = create(:assessment, competition:, discipline: la, band:, forced_name: 'TGL')

      get "/#{competition.year}/#{competition.slug}/teams/#{team.id}/edit_assessment_requests"
      expect(response).to match_html_fixture.with_affix('edit-assessment-requests')

      expect do
        patch "/#{competition.year}/#{competition.slug}/teams/#{team.id}?form=edit_assessment_requests",
              params: { team: { requests_attributes: {
                '0' => {
                  '_destroy' => '0',
                  'assessment_id' => assessment.id,
                  'assessment_type' => 'group_competitor',
                  'id' => assessment.requests.first.id,
                },
                '1' => {
                  '_destroy' => '0',
                  'assessment_id' => tgl.id,
                  'assessment_type' => 'out_of_competition',
                },
              } } }
      end.to change(AssessmentRequest, :count).by(1)

      get "/#{competition.year}/#{competition.slug}/teams/#{team.id}"
      expect(response).to match_html_fixture.with_affix('show-assessment-requests')

      patch "/#{competition.year}/#{competition.slug}/teams/#{team.id}?form=edit_assessment_requests",
            params: { team: { requests_attributes: {
              '0' => {
                '_destroy' => '0',
                'assessment_id' => assessment.id,
                'assessment_type' => 'group_competitor',
                'id' => assessment.requests.first.id,
              },
              '1' => {
                '_destroy' => '0',
                'assessment_id' => tgl.id,
                'assessment_type' => '',
              },
            } } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end