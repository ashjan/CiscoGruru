class API::V1::CollaboratorsController < ApplicationController
  before_action :set_schema

  # List the collaborators for the schema
  # @todo check current user
  # GET /api/v1/schemas/:schema_id/collaborators
  def index
    @collaborators = @schema.user_schemas.map do |user_schema|
      {
        id: user_schema.user.id,
        username: user_schema.user.username,
        email: user_schema.user.email,
        image: user_schema.user.image,
        access_mode: user_schema.access_mode_integer
      }
    end
  end

  # POST /api/v1/schemas/:schema_id/collaborators
  def create
    email = params[:email]
    if email.blank?
      render json: {
        status: 'fail',
        message: "Invalid e-mail"
      }, status: :unauthorized
      return
    end
    if @schema.users.count >= 10
      render json: {
        status: 'fail',
        message: "You can't add more than 10 collaborators"
      }, status: :unauthorized
      return
    end
    email = email.strip.downcase
    @user = User.find_by email: email
    unless @user
      temp_password = SecureRandom.hex
      @user = User.create!({
        email: email,
        password: temp_password,
        password_confirmation: temp_password,
        invited: true
        })
      if params[:send_invitation_mail]
        _invite_user(@user)
      end
    end
    @schema.user_schemas.create({
      user: @user,
      access_mode: params[:access_mode].to_i
      })
    # @schema.users << @user
    render 'collaborator'
  end

  # DELETE /api/v1/schemas/:schema_id/collaborators/:id
  def destroy
    @user = User.find params[:id]
    
    logger.info "Deleting collaborator: #{@user.id} from schema: #{@schema.id}"

    @schema.users.delete(@user)
    render 'collaborator'
  end

  private

  def _invite_user(user)
    verifier = ActiveSupport::MessageVerifier.new("secret")
    token = verifier.generate({
      user_id: user.id,
      expires: 30.days.from_now})
    UserMailer.collaboration_invitation({
      inviter: current_user,
      invitee: user,
      token: CGI::escape(::Base64.urlsafe_encode64(token))
      }).deliver_now
  end

  def set_schema
    @schema = Schema.find params[:schema_id]
  end
end
