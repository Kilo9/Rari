module CarsHelper
  def is_active?(filter)
    return false unless params[:filter]
    return filter == params[:filter]
  end
end
