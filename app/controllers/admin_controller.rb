class AdminController < ApplicationController
  before_action :authenticate_admin, :set_payment_count
  layout 'admin'

  # GET /yonetim
  # admin dashboard
  def index
  end

  # GET /yonetim/users
  def users
    sort_field = params.fetch(:sort_field, "id")
    sort_direction = params.fetch(:sort_direction, "desc")
    @users = User.all
    account_filter = params.fetch(:account_filter, "")
    if account_filter == "translator"
      @users = @users.includes(:account).where(accounts: {account_type: 2})
    end
    if ["pro", "temp_pro"].include? account_filter
      @users = @users.includes(:account).where(accounts: {account_type: 1})
    end
    if account_filter == "invited"
      @users = @users.where(invited: true)
    end
    @users = @users.order(sort_field => sort_direction).page(params.fetch(:page, 0)).per(25)
  end

  # GET /yonetim/user/:id
  def show_user
    @user = User.find params[:id]
    @collab_schemata = @user.schemas.where.not(owner_id: @user.id)
    if @user.app_settings
      @language = JSON.parse(@user.app_settings)['language']
    end
  end

  # GET /yonetim/user/:id/set_translator
  # toggle the user's translator status
  def set_translator
    user = User.find params[:id]
    if user.account.translator?
      user.account.update(account_type: "free")
    else
      user.account.update(account_type: "translator")
    end
    redirect_to "/yonetim/user/#{user.id}"
  end

  # GET /yonetim/schemata
  def schemata
    sort_field = params.fetch(:sort_field, "id")
    sort_direction = params.fetch(:sort_direction, "desc")
    
    @schemata = Schema.includes(:owner).order(sort_field => sort_direction)

    db_filter = params.fetch(:db_filter, "")
    if ["mysql", "postgres", "sqlite", "mssql", "oracle"].include? db_filter
      @schemata = @schemata.where(db: db_filter)
    end
    @schemata = @schemata.page(params.fetch(:page, 0))
  end

  # GET /yonetim/schema/:id
  def schema
    @schema = Schema.find params[:id]
  end

  # GET /yonetim/feedbacks
  def feedbacks
    @feedbacks = Feedback.includes(:user).order(id: :desc).page(params.fetch(:page, 0))
  end

  # GET /yonetim/feedback/:id
  def feedback
    @feedback = Feedback.find params[:id]
  end

  # GET /yonetim/comments
  def comments
    sort_field = params.fetch(:sort_field, "id")
    sort_direction = params.fetch(:sort_direction, "desc")
    @comments = SchemaComment
      .includes(:user)
      .includes(:schema)
      .order(sort_field => sort_direction)
      .page(params.fetch(:page, 0))
  end

  # POST /yonetim/search?query=text
  def search
    if params[:query][0] == "_"
      @schemata = Schema.where("title like '%#{params[:query][1..-1]}%'")
      @schemata = @schemata.page(params.fetch(:page, 0))
      render "admin/schemata"
      return
    end
    if params[:query][0] == "+"
      @users = User
        .where('lower(username) LIKE ?', "%#{params[:query][1..-1].downcase}%")
        .page(params.fetch(:page, 0))
    elsif params[:query][0..1] == "@@"
      @users = User
        .joins(:oauth_profiles)
        .where(oauth_profiles: {"username" => params[:query][2..-1]})
        .page(params.fetch(:page, 0))
    else
      @users = User
        .where('lower(email) LIKE ?', "%#{params[:query].downcase}%")
        .page(params.fetch(:page, 0))
    end
    render 'admin/users'
  end

  # Advanced search page
  #
  # GET /yonetim/adv_search
  # POST /yonetim/adv_search
  def adv_search
    @schema = params.fetch(:schema, "").downcase
    @username = params.fetch(:username, "").downcase
    @email = params.fetch(:email, "").downcase
    @oauth = params.fetch(:oauth, "").downcase

    if @schema != ""
      @schemata = Schema.where("title like '%#{@schema}%'")
      @schemata = @schemata.page(params.fetch(:page, 0))
      if @schemata.count > 0
        render "admin/schemata"
        return
      end
      @alert = "No results were found with the given criteria"
    end
    if @username != ""
      @users = User
        .where('lower(username) LIKE ?', "%#{@username}%")
        .page(params.fetch(:page, 0))
      if @users.count > 0
        render 'admin/users'
        return
      end
      @alert = "No results were found with the given criteria"
    end
    if @email != ""
      @users = User
        .where('lower(email) LIKE ?', "%#{@email}%")
        .page(params.fetch(:page, 0))
      if @users.count > 0
        render 'admin/users'
        return
      end
      @alert = "No results were found with the given criteria"
    end
    if @oauth != ""
      @users = User
        .joins(:oauth_profiles)
        .where(oauth_profiles: {"username" => @oauth})
        .page(params.fetch(:page, 0))
      if @users.count > 0
        render 'admin/users'
        return
      end
      @alert = "No results were found with the given criteria"
    end
  end

  # GET /yonetim/payments
  def payments
    @payments = Payment.order(:created_at => :desc).page(params.fetch(:page, 0))
    @payment_totals = Payment.get_totals
  end

  # GET /ghost/:id
  # login as user
  def ghost
    session[:user_id] = params[:id]
    session[:was_admin] = current_user.id
    redirect_to designer_path
  end

  # GET /yonetim/logins
  def logins
    sort_field = params.fetch(:sort_field, "id")
    sort_direction = params.fetch(:sort_direction, "desc")
    @logins = Login
      .all
      .order(sort_field => sort_direction)
      .page(params.fetch(:page, 0))
  end

  # GET /yonetim/new_article
  def new_article
    @article = Article.new
    render 'admin/new_article'
  end

  # POST /yonetim/blog/create_article
  def create_article
    article = Article.new
    article.title = params[:title]
    article.slug = params[:slug]
    article.brief_md = params[:brief]
    article.content_md = params[:contents]
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
    article.brief_html = markdown.render params[:brief]
    article.content_html = markdown.render params[:contents]
    article.is_published = params[:is_published]
    article.is_sponsored = params[:is_sponsored]
    article.view_count = 0
    article.save!
    redirect_to '/yonetim/blog'
  end

  # GET /yonetim/blog/edit/:id
  def edit_article
    @article = Article.find params[:id]
    render 'admin/edit_article'
  end

  # POST /yonetim/blog/update/:id
  def update_article
    article = Article.find params[:id]
    article.title = params[:title]
    article.slug = params[:slug]
    article.brief_md = params[:brief]
    article.content_md = params[:contents]
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
    article.brief_html = markdown.render params[:brief]
    article.content_html = markdown.render params[:contents]
    article.is_published = params[:is_published]
    article.is_sponsored = params[:is_sponsored]
    article.save!
    if params[:continue]
      flash[:notice] = "Article is saved..."
      redirect_to "/yonetim/blog/edit/#{article.id}"
    else
      redirect_to '/yonetim/blog'
    end
  end

  # GET /yonetim/blog
  def blog
    sort_field = params.fetch(:sort_field, "id")
    sort_direction = params.fetch(:sort_direction, "desc")
    
    @articles = Article.order(sort_field => sort_direction).page(params.fetch(:page, 0)).per(25)
    render 'admin/articles'
  end

  private

  # sets a variable for the toolbar payments badge
  def set_payment_count
    @payment_count = Payment.where("DATE(created_at) = ?", Date.today.to_date).count
    @payment_count = nil if @payment_count == 0
  end
end
