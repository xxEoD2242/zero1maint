class WelcomeController < ApplicationController
  before_action :authenticate_user!, only: [:homepage]
  def homepage
  end
  def fare_harbor_data
  end
end
