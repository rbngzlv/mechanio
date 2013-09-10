module ControllerMacros

  def login_user(user = nil)
    set_devise_mapping(:user)
    user ||= create :user
    sign_in user
  end

  def login_admin(admin = nil)
    set_devise_mapping(:admin)
    admin ||= create :admin
    sign_in admin
  end

  def set_devise_mapping(model)
    @request.env["devise.mapping"] = Devise.mappings[model]
  end
end

RSpec.configure do |config|
  config.before :each, type: :controller do |c|
    case c.controller.class.name.deconstantize
      when "Admin" then set_devise_mapping(:admin)
      when "Users" then set_devise_mapping(:user)
    end
  end
end
