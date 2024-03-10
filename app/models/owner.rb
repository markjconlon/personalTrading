# frozen_string_literal: true

class Owner < ApplicationRecord
  has_many :accounts

  def name
    "#{firstname} #{lastname}"
  end
end
