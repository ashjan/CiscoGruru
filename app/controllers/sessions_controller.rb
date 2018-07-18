class SessionsController < ApplicationController
  # GET /
  # redirects to login page, allows hitting refresh on login error
  def index
    redirect_to new_session_path
  end

  # GET /login
  # GET /sessions/new
  def new
  end

  # GET /sessions/oauth
  # GET /auth/:provider/callback
  def oauth
    profile = OAuthProfile.from_omniauth(env['omniauth.auth'])
    # TODO check for error
    # temp_password = SecureRandom.hex
    if !profile.user
      oauth_custom_params = request.env["omniauth.params"] || {}
      session[:oauth_reason] = oauth_custom_params.fetch("dbdesigner_action", "")
      session[:profile_id] = profile.id
      redirect_to new_registration_path
      # profile.user.create({
      #   username: profile.username,
      #   email: profile.email,
      #   password: temp_password,
      #   password_confirmation: temp_password
      #   })
    else
      session[:user_id] = profile.user.id
      profile.user.record_login(request: request, oauth_profile: profile)
      redirect_to designer_path
    end
  end

  # POST /sessions
  def create
    logger.info params
    @user = User.find_by(email: params[:email], deleted: false)
    if @user.try(:authenticate, params[:password])
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
      @user.record_login(request: request) unless @user.id == 1

      respond_to do |format|
        format.html {
          if @user.id == 1 && Rails.env.production?
            redirect_to 'https://www.dbdesigner.net/yonetim'
          else
            redirect_to designer_path
          end
        }
        format.json {
          render json: {
            status: "success",
            message: "login successful",
            user: {
              username: @user.username,
              email: @user.email
            }
          }
        }
      end
    else
      check_admin_fail
      respond_to do |format|
        format.html {
          flash.now[:alert] = "Wrong username or password"
          render :new
        }
        format.json {
          render json: {
            status: "fail",
            message: "Wrong username or password"
          }
        }
      end
    end
  end

  # GET /logout
  # POST /logout
  # DELETE /sessions
  def destroy
    if session[:was_admin]
      session[:user_id] = session[:was_admin]
      session.delete :was_admin
    else
      session[:user_id] = nil
    end
    redirect_to login_path
  end

  # GET /auth/failure
  # OAuth failure callback path
  def auth_failure
    logger.warn "[SESS] auth failure: #{params[:message]}"
    redirect_to new_session_path
  end

  # Password recovery {{{

  # GET /password-recovery/remind-password
  def remind_password
  end

  # POST /password-recovery/send-reminder
  def send_reminder
    user = User.find_by email: params[:email]
    if user
      token = SecureRandom.urlsafe_base64
      user.update password_reset_digest: token
      UserMailer.password_recovery(user: user, token: token).deliver_now
      redirect_to '/password-recovery/reminder-sent'
    else
      flash[:alert] = "Invalid e-mail address"
      redirect_to "/password-recovery/remind-password"
    end
  end

  # GET /password-recovery/reminder-sent
  # The success page after the user enters e-mail for password recovery
  def reminder_sent
  end

  # GET /password-recovery/recover/:token
  # The page where the user lands coming from the password recovery e-mail
  def recover
    @user = User.find_by password_reset_digest: params[:token]
    if !@user
      flash[:alert] = 'Invalid link'
      redirect_to '/password-recovery/remind-password'
      return
    end
    @token = params[:token]
  end

  # POST /password-recovery/change-password
  def change_password
    @user = User.find_by password_reset_digest: params[:token]
    if !@user
      flash[:alert] = 'Invalid user'
      redirect_to '/password-recovery/remind-password'
      return
    end
    if @user.update password: params[:password], password_confirmation: params[:password_confirmation]
      flash[:notice] = "Your password has been changed. Please login to continue."
      redirect_to '/login'
    else
      @token = params[:token]
      flash[:alert] = @user.errors.full_messages.to_sentence
      redirect_to "/recover/#{params[:token]}"
    end
  end

  # }}}

  private

  def check_admin_fail
    if @user.try(:id) == 1 && Rails.env.production?
      Rails.cache.write("block #{request.remote_ip}", true, expires_in: 30.minutes)
      AdminMailer.wrong_credentials_alert(params[:password], request.remote_ip).deliver_now
    end
  end
end
