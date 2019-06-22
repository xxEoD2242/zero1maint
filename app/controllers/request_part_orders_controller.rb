# frozen_string_literal: true

class RequestPartOrdersController < ApplicationController
  def destroy
    @part_order = RequestPartOrder.find(params[:id])
    @part_order.destroy
    flash[:notice] = 'Part was successfully removed from the work order!' if @part_order.destroy
    redirect_back(fallback_location: root_path)
  end
end
