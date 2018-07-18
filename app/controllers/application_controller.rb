class ApplicationController < ActionController::Base
  include AppErrors

  protect_from_forgery with: :null_session

  def current_user
    @current_user ||= if session[:user_id]
      User.find_by(id: session[:user_id])
    else
      Guest.new
    end
  end
  helper_method :current_user

  def user_signed_in?
    current_user.is_signed_in?
  end
  helper_method :user_signed_in?

  def authenticate_user
    unless current_user.is_signed_in?
      redirect_to '/login'
    end
  end

  def authenticate_admin
    if current_user.id != 1
      redirect_to '/login'
    end
  end

  rescue_from OwnershipError, with: :render_ownership_error

  def render_ownership_error
    if !current_user.is_signed_in?
      render json: {
        status: 'fail',
        message: "You are not logged in"
      }, status: :unauthorized
    else
      render json: {
        status: 'fail',
        message: "This schema does not belong to you"
      }, status: :unauthorized
    end
  end

  def check_schema_ownership(schema)
    if (!current_user.is_signed_in?) || ((current_user.id != 1) && (schema.owner.id != current_user.id)) && (!schema.users.include?(current_user))
      logger.warn "OwnershipError(schema:#{schema.id}, current_user:#{current_user.id})"
      raise OwnershipError
    end
  end
end
