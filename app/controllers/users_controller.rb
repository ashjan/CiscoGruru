class UsersController < ApplicationController
  # GET /account
  def account
    redirect_to "/login" and return unless current_user.is_signed_in?
    @payments = current_user.account.payments.order(created_at: :desc)
  end

  # POST /users/update_profile
  def update_profile
    unless current_user.is_signed_in?
      head :unauthorized and return
    end
    if current_user.update user_params
      respond_to do |format|
        format.json do
          render json: {
            username: current_user.username,
            email: current_user.email
          }
        end
        format.html do
          if current_user.schemas.present?
            redirect_to "/designer/schema/#{current_user.schemas.first.id}"
          else
            redirect_to designer_path
          end
        end
      end
    else
      respond_to do |format|
        format.json { head 422 }
        format.html {
          flash[:alert] = current_user.errors.full_messages.to_sentence
          redirect_to :back
        }
      end
    end
  end

  # POST /users/save_settings
  # saves app settings of user
  # called from the application settings dialog
  def save_settings
    unless current_user.is_signed_in?
      head :unauthorized and return
    else
      current_user.app_settings = params[:settings]
      current_user.save
      render json: {status: 1}
    end
  end

  # PATCH /update-account
  def update_account
    current_user.update user_params
    redirect_to '/account'
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:username, :email, :password, :password_confirmation, :newsletter_subscription)
  end
end
