class API::V1::SchemaCommentsController < ApplicationController
  before_action :set_schema

  # GET /api/v1/schemas/:schema_id/schema_comments
  def index
  end

  # POST /api/v1/schemas/:schema_id/schema_comments
  def create
    @schema_comment = SchemaComment.new schema_comment_params
    @schema_comment.schema = @schema
    @schema_comment.user = current_user
    if @schema_comment.save
      render json: @schema_comment
    else
      render json: @schema_comment.errors
    end
  end

  # DELETE /api/v1/schemas/:schema_id/schema_comments/:id
  def destroy
    @schema_comment = SchemaComment.find params[:id]
    if @schema_comment.user != current_user
      head 500
    else
      @schema_comment.destroy
      render json: @schema_comment
    end
  end

  private

  def set_schema
    @schema = Schema.find params[:schema_id]
  end

  def schema_comment_params
    params.require(:schema_comment).permit(:contents)
  end
end
