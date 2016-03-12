class WelcomeController < ApplicationController
  def index
    is_redirect = false
    [:alert, :timecrowd].each do |sym|
      if params[sym]
        cookies[:settings] = Setting.set cookies, sym
        is_redirect = true
      end
    end
    if params[:cancel]
      Setting.del cookies, params[:cancel]
      is_redirect = true
    end
    redirect_to :root if is_redirect
  end
end

