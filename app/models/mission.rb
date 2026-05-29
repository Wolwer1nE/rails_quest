class Mission < ApplicationRecord
  belongs_to :agent

  validates :title, presence: true
  validates :status, presence: true

  VALID_STATUSES = ['pending', 'in_progress', 'completed', 'failed'].freeze

  def status=(value)
    if value.present? && !VALID_STATUSES.include?(value)
      raise ArgumentError, "Invalid status: #{value}"
    end
    super(value)
  end
end
