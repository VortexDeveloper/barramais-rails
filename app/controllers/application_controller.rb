class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verified_request?

  def verified_request?
    if request.content_type == "application/json"
      true
    else
      super
    end
  end
end
