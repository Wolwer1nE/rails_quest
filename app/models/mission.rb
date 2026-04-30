class Mission < ApplicationRecord
  belongs_to :agent

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[assigned in_progress completed] }

  def status=(value)
    if value.nil?
      super(value)
    elsif !%w[assigned in_progress completed].include?(value.to_s)
      raise ArgumentError, "'#{value}' is not a valid status"
    else
      super(value)
    end
  end
end