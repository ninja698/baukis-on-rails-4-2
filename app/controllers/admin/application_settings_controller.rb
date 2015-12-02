class Admin::ApplicationSettingsController < Admin::Base

  def edit
    @application_setting = ApplicationSetting.first
  end

  def update
    @application_setting = ApplicationSetting.first
    @application_setting.assign_attributes(application_setting_params)
    if @application_setting.save
      flash.notice = 'アプリケーション設定を変更しました。'
      redirect_to :admin_root
    else
      flash.now.alert = 'アプリケーション設定の入力値が正しくありません。'
      render 'edit'
    end
  end

  private
  def application_setting_params
    params.require(:application_setting).permit(:application_name, :expiration_of_session)
  end

end