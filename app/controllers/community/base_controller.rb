module Community
  class BaseController < ApplicationController
    skip_before_filter :authenticate_employee!
  end
end