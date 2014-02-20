module LolitaBankLink
  class ApplicationController < ActionController::Base
    include ActiveModel::ForbiddenAttributesProtection
    skip_before_filter :verify_authenticity_token

  end
end
