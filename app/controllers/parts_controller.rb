class PartsController < InheritedResources::Base

  private

    def part_params
      params.require(:part).permit(:part_id, :description, :brand, :category, :cost, :quantity)
    end
end

