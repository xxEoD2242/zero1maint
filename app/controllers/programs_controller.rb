# frozen_string_literal: true

class ProgramsController < ApplicationController
  before_action :set_program, only: %i[show edit update destroy]

  def index
    @programs = Program.all
  end

  def show; end

  def new
    @program = Program.new
  end

  def edit; end

  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        UserMailer.new_service_request_email(@program).deliver_now
        format.html { redirect_to @program, notice: 'Service was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @program.update(program_params)
        UserMailer.update_service_email(@program).deliver_now
        format.html { redirect_to @program, notice: 'Service was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_url, notice: 'Service was successfully destroyed.' }
    end
  end

  private

  def set_program
    @program = Program.find(params[:id])
  end

  def program_params
    params.require(:program).permit(:name, :rzr_interval, :completed, :threshold, :threshold_numb,
                                    :fleet_interval, :tour_car_interval, :db_interval, :other_interval,
                                    :training_interval, request_ids: [])
  end
end
