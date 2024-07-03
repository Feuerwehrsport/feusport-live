# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Firesport::Series::Team::VierBahnenPokal do
  describe '#points_for_result' do
    it 'calculates points for result' do
      expect(described_class.points_for_result(1, nil, nil, gender: nil)).to eq 0
      expect(described_class.points_for_result(2, nil, nil, gender: nil)).to eq 2
      expect(described_class.points_for_result(3, nil, nil, gender: nil)).to eq 3
      expect(described_class.points_for_result(4, nil, nil, gender: nil)).to eq 4
      expect(described_class.points_for_result(5, nil, nil, gender: nil)).to eq 5
      expect(described_class.points_for_result(6, nil, nil, gender: nil)).to eq 6
      expect(described_class.points_for_result(7, nil, nil, gender: nil)).to eq 7
      expect(described_class.points_for_result(8, nil, nil, gender: nil)).to eq 8
      expect(described_class.points_for_result(9, nil, nil, gender: nil)).to eq 9
      expect(described_class.points_for_result(10, nil, nil, gender: nil)).to eq 10
      expect(described_class.points_for_result(11, nil, nil, gender: nil)).to eq 11
      expect(described_class.points_for_result(12, nil, nil, gender: nil)).to eq 12
      expect(described_class.points_for_result(13, nil, nil, gender: nil)).to eq 13
      expect(described_class.points_for_result(14, nil, nil, gender: nil)).to eq 14
      expect(described_class.points_for_result(15, nil, nil, gender: nil)).to eq 15
      expect(described_class.points_for_result(16, nil, nil, gender: nil)).to eq 16
      expect(described_class.points_for_result(17, nil, nil, gender: nil)).to eq 17
    end
  end
end