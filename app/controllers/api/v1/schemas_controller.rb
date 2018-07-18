class API::V1::SchemasController < ApplicationController
  before_action :set_schema, only: [:show, :update, :destroy]
  # before_action :authenticate_user
  skip_before_action :verify_authenticity_token

  # GET /api/v1/schemas
  def index
    @own_schemas = current_user.own_schemas.where(deleted: false).order(updated_at: :desc)
    @shared_schemas = current_user.schemas.where(deleted: false).order(updated_at: :desc)
  end

  # GET /api/v1/schemas/templates
  def templates
    @schemas = Schema.templates.not_deleted.order(updated_at: :desc)
  end

  # GET /api/v1/schemas/:id
  def show
    if @schema.deleted?
      render json: {
        status: 'fail',
        message: "Schema does not exist"
      }, status: :unauthorized
      return
    end
    unless @schema.template?
      check_schema_ownership(@schema)
    end
    if params[:version_id]
      @schema.schema_data = @schema.schema_versions.find(params[:version_id]).schema_data
    end
  end

  # POST /api/v1/schemas
  def create
    @schema = Schema.new(schema_params)
    unless current_user.is_signed_in?
      render json: {
        message: 'You are not logged in'
        }, status: :unauthorized
      return
    end
    @schema.owner = current_user
    if @schema.save
      @schema.generate_version(user: current_user)
      render action: 'show', status: :created
    else
      render json: @schema.errors, status: :unprocessable_entry
    end
  end

  # PUT /api/v1/schemas/:id
  # PATCH /api/v1/schemas/:id
  def update
    check_schema_ownership(@schema)
    if current_user != @schema.owner
      _user = @schema.user_schemas.find_by(user: current_user)
      if !_user || !_user.can_read_write?
        render json: {
          status: 'fail',
          message: "You can not make changes to this schema"
        }, status: :unauthorized
        return
      end
    end
    if @schema.update(schema_params)
      @schema.generate_version(user: current_user)
      render :show
    else
      render json: @schema.errors, status: 422
    end
  end

  # DELETE /api/v1/schemas/:id
  def destroy
    check_schema_ownership(@schema)
    @schema.update deleted: true
    render json: {}
  end

  # GET /api/v1/schemas/:id/generate_sql
  def generate_sql
    schema = JSON.parse(schema_params["schema_data"])
    script_type = schema_params["script_type"]
    sql = Cosql::get_generator(schema).generate(script_type: script_type)
    render json: {
      status: :success,
      sql: sql
    }
  rescue Cosql::InvalidSchemaError
    render json: {
      status: :invalid_schema,
      sql: 'Invalid Schema'
    }
  end

  # POST /api/v1/schemas/import_sql
  def import_sql
    unless current_user.is_signed_in?
      render json: {
        message: 'You are not logged in'
        }, status: :unauthorized
      return
    end
    sql = params[:sql]
    db = params[:db]
    File.write("tmp/sqls/u#{current_user.id}-#{db}-#{Time.now.to_i}-#{SecureRandom.hex(4)}.sql", sql)
    parser = Cosql::get_parser(db, sql)
    schema = Schema.create(
      title: 'Untitled',
      owner: current_user,
      db: db,
      schema_data: parser.parse.to_json)
    render json: {id: schema.id}
  rescue Cosql::InvalidSqlError => e
    puts e.message
    render json: {
      status: :invalid_schema,
      message: "Invalid sql: #{e.message}",
      line: e.line,
      column: e.column,
      index: e.index
    }
  end

  # GET /api/v1/schemas/wait
  def wait
    sleep 3
    render json: {
      foo: :bar
    }
  end

  private

  def set_schema
    @schema = Schema.find params[:id]
  end

  def schema_params
    params
      .require(:schema)
      .permit(:title, :schema_data, :template, :db, :script_type)
  end
end

