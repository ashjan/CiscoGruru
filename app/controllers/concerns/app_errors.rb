module AppErrors
  extend ActiveSupport::Concern

  class OwnershipError < StandardError; end
end