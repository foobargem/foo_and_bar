require 'base_helper/base_application'
require 'base_helper/base_controller'

ActionView::Base.send(:include, BaseApplication)
ActionController::Base.send(:include, BaseContoller)
