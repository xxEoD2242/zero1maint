# frozen_string_literal: true

class ReportUser < ApplicationRecord
  belongs_to :user
  belongs_to :report
end
