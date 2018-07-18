class DesignerController < ApplicationController
  # GET /designer
  # GET /designer/schema/:schema_no
  def index
  end

  # GET /designer/schema:/schema_no/versions
  def versions
    @schema = Schema.find(params[:schema_no])
    @schema_versions = @schema.schema_versions.order(:created_at => :desc)
    render :versions, layout: 'application'
  end

  def show_version
    render :index
  end
end
