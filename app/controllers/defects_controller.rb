# frozen_string_literal: true

class DefectsController < ApplicationController
  def by_event
    @vehicles = Vehicle.all
    @q = Event.where(defects_reported: true).ransack(params[:q])
    @event_results = @q.result.order(id: :desc).page(params[:page])
  end

  def index
    @vehicles = Vehicle.all
    @q = Defect.all.order(id: :desc).ransack(params[:q])
    @defects = @q.result.page(params[:page])
  end

  def create
    @defect = Defect.new(defect_params)
    respond_to do |format|
      if @defect.save
        format.html { redirect_to @defect, notice: 'Defect was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @defect.update(defect_params)
        format.html { redirect_to @defect, notice: 'Defect was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @defect.destroy
    respond_to do |format|
      format.html { redirect_to defects_url, notice: 'Defect was successfully destroyed.' }
    end
  end

  private

  def set_defect
    @defect = Defect.find(params[:id])
  end

  def defect_params
    params.require(:defect).permit(:date_fixed, :vehicle_id, :checklist_id, :request_id, :fixed, :description, :category)
  end
end
