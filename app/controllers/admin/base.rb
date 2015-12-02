class Admin::Base < ApplicationController
  before_action :check_source_ip_address
  before_action :authorize
  before_action :check_account
  before_action :initialize_application_setting
  before_action :get_timeout
  before_action :check_timeout

  private
  def current_administrator
    if session[:administrator_id]
      @current_administrator ||=
        Administrator.find_by(id: session[:administrator_id])
    end
  end

  helper_method :current_administrator

  def check_source_ip_address
    raise IpAddressRejected unless AllowedSource.include?('admin', request.ip)
  end

  def authorize
    unless current_administrator
      flash.alert = '管理者としてログインしてください。'
      redirect_to :admin_login
    end
  end

  def check_account
    if current_administrator && current_administrator.suspended?
      session.delete(:administrator_id)
      flash.alert = 'アカウントが無効になりました。'
      redirect_to :admin_root
    end
  end

  #new,createを一回きりのために記述するのを避け、事前に初期設定(オブジェクト)が育成されている仕様にしました。
  def initialize_application_setting
    unless ApplicationSetting.exists?
      ApplicationSetting.create(application_name: "Baukis", expiration_of_session: "60")
    end
  end

  def get_timeout
    if ApplicationSetting.exists?
      @TIMEOUT = ApplicationSetting.first.expiration_of_session.minutes
    else
      @TIMEOUT = 60.minutes
    end
  end

  def check_timeout
    if current_administrator
      unless @TIMEOUT == 0
        if session[:last_access_time] >= @TIMEOUT.ago
          session[:last_access_time] = Time.current
        else
          session.delete(:administrator_id)
          flash.alert = 'セッションがタイムアウトしました。'
          redirect_to :admin_login
        end
      end
    end
  end
end
