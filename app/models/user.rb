# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w[admin employee ghost].freeze

  has_many :request_users

  has_many :requests, through: :request_users
  has_many :request_part_orders

  has_many :checklists

  def admin?
    role == 'admin'
  end

  def employee?
    role == 'employee'
  end

  def ghost?
    role == 'ghost'
  end

  def user_naming
    "&nbsp #{name} &nbsp".html_safe
  end
end
