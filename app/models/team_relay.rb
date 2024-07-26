# frozen_string_literal: true

class TeamRelay < ApplicationRecord
  belongs_to :team, touch: true
  has_many :list_entries, class_name: 'Score::ListEntry', as: :entity, dependent: :destroy, inverse_of: :entity

  validates :team, :number, presence: true
  delegate :fire_sport_statistics_team, :fire_sport_statistics_team_id, :band, to: :team

  schema_validations

  def name
    (64 + number).chr
  end

  def full_name
    "#{team.full_name} #{name}"
  end

  def full_name_with_band
    "#{team.full_name_with_band} #{name}"
  end

  def shortcut_name
    "#{team.shortcut_name} #{name}"
  end

  def self.create_next_free_for(team, not_ids)
    existing = where(team:).where.not(id: not_ids).reorder(:number).first
    return existing if existing.present?

    create_next_free team
  end

  def self.create_next_free(team)
    new_number = (team.team_relays.reorder(:number).pluck(:number).last || 0) + 1
    team.team_relays.create(number: new_number)
  end
end
