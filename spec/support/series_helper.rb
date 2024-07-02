# frozen_string_literal: true

def generate_series_person_participations(h)
  h.map do |key, values|
    aggr = described_class.new(nil, key)
    values.each do |value|
      aggr.add_participation(Series::PersonParticipation.new(points: value.first, time: value.last))
    end
    aggr
  end
end
