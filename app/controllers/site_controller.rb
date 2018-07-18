class SiteController < ApplicationController
  # GET /
  # GET /site/index
  def index
    @hide_navbar = true
  end

  # GET /pricing
  def pricing
  end

  # GET /terms-of-service
  def terms_of_service
  end

  # GET /privacy
  def privacy
  end

  # GET /changelog
  def changelog
  end

  # GET /translations
  def translations
  end
end
