# frozen_string_literal: true

class Discipline < ApplicationRecord
  DISCIPLINES = %w[la hl hb zk gs fs other].freeze
  DEFAULT_NAMES = {
    la: 'Löschangriff nass',
    hl: 'Hakenleitersteigen',
    hb: '100m-Hindernisbahn',
    zk: 'Zweikampf',
    gs: 'Gruppenstafette',
    fs: '4x100m-Feuerwehrstafette',
    other: 'Andere',
  }.with_indifferent_access.freeze
  DEFAULT_SINGLE_DISCIPLINES = {
    la: false,
    hl: true,
    hb: true,
    zk: true,
    gs: false,
    fs: false,
    other: false,
  }.with_indifferent_access.freeze

  belongs_to :competition
  has_many :assessments, dependent: :restrict_with_error

  schema_validations
  validates :key, inclusion: { in: DISCIPLINES }

  def destroy_possible?
    assessments.empty?
  end
end
