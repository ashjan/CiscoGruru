class RegistrationsController < ApplicationController
  # GET /registrations
  # redirects to new registration page, allows hitting refresh on registration error
  def index
    redirect_to new_registration_path
  end

  # GET /registrations/new
  def new
    @user = User.new
    if session.key?(:profile_id)
      profile = OAuthProfile.find session[:profile_id]
      oauth_reason = session.fetch(:oauth_reason, '')
      if oauth_reason == "login"
        flash[:alert] = "Your #{profile.try(:provider_str)} account can't be matched with an account. Please register or Login with your existing account"
      else # register
        flash[:notice] = "Please complete your registration by choosing a password"
      end
      if profile
        @user.email = profile.email
        @user.username = profile.username
      else
        logger.warn "[REGS] missing profile albeit session[:profile_id]=#{session[:profile_id]}"
      end
    end
    if params.key?(:plan_id)
      @plan_id = params.fetch(:plan_id, 0)
      session[:plan_id] = @plan_id
    elsif session.key?(:plan_id)
      @plan_id = session[:plan_id]
    else
      @plan_id = 0
    end
  end

  # POST /registrations
  def create
    @user = User.new user_params
    @user.email = @user.email.downcase
    if @user.save
      session[:user_id] = @user.id
      if session.key?(:profile_id)
        profile = OAuthProfile.find session[:profile_id]
        if profile
          @user.oauth_profiles << profile
        else
          logger.warn "[REGS] missing profile albeit session[:profile_id]=#{session[:profile_id]}"
        end
        session.delete(:profile_id)
      end
      # AdminMailer.registration(@user.id).deliver_later
      if params[:plan_id] && params[:plan_id].to_i != 0
        logger.info "[PAYMENT] redirected user #{@user.id} to paddle, plan: #{params[:plan_id]}"
        redirect_to "https://pay.paddle.com/checkout/#{params[:plan_id]}?guest_email=#{@user.email}&quantity_variable=0&passthrough=#{@user.id}&success=https://www.dbdesigner.net/registrations/thankyou"
        return
      end
      if @user.schemas.present?
        redirect_to "/designer/schema/#{@user.schemas.first.id}"
      else
        redirect_to designer_path
      end
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  # GET /registrations/invite/:token
  # This is where an invited user first comes to
  def invite
    verifier = ActiveSupport::MessageVerifier.new("secret")
    begin
      message = verifier.verify(::Base64.urlsafe_decode64(params[:token]))
    rescue ActiveSupport::MessageVerifier::InvalidSignature, ArgumentError
      logger.warn "Invalid invite link: #{params[:token]}"
      flash[:alert] = 'Invalid link'
      redirect_to new_registration_path and return
    end
    @user = User.find_by(id: message[:user_id])
    unless @user
      flash[:alert] = 'Invalid link'
      redirect_to new_registration_path and return
    end
    unless current_user.is_signed_in?
      session[:user_id] = @user.id
      flash[:notice] = "Please select a username and password to complete your registration"
    end
  end

  # GET /registrations/thankyou
  def thankyou
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :newsletter_subscription)
  end
end
