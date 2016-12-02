class Frequency < ActiveRecord::Base
  belongs_to :script
  scope :active, -> (time) { where("(EXTRACT(EPOCH FROM last_run) + epoch < '#{time.to_i}') OR first_exec < '#{time}' AND last_run IS NULL") }
end
