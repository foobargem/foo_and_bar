class Admin::SessionsController < Devise::SessionsController

  before_filter :authenticate_admin!, :only => [:destroy]
  
  layout "blank"

  include Devise::Controllers::InternalHelpers

  # GET /resource/sign_in
  def new    
    set_flash_message :notice, :admin_login
    clean_up_passwords(build_resource)
    render_with_scope :new
  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "admin/sessions#new")
    set_flash_message :notice, :signed_in
    sign_in_and_redirect(resource_name, resource)
  end

  # GET /resource/sign_out
  def destroy
    set_flash_message :notice, :signed_out if signed_in?(resource_name)
    sign_out_and_redirect(resource_name)
  end
  
end
