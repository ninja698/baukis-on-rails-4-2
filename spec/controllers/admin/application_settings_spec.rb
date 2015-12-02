require 'rails_helper'

describe Admin::ApplicationSettingsController, 'ログイン前' do
  context '#edit' do
    example 'ログインフォームにリダイレクト' do
      get :edit
      expect(response).to redirect_to(admin_login_url)
    end
  end
end

describe Admin::ApplicationSettingsController do
  let(:administrator) { create(:administrator) }
  let(:params_hash) { attributes_for(:application_setting) }

  before do
    session[:administrator_id] = administrator.id
    session[:last_access_time] = 1.second.ago
  end

  describe '#update' do
    context 'valid' do
      before do
        patch :update, application_setting: params_hash
      end
      example 'admin用TOPページにリダイレクト' do
        expect(response).to redirect_to(admin_root_url)
      end
      example 'セッションタイムアウトがファクトリと同値' do
        timeout = ApplicationSetting.first.expiration_of_session
        expect(timeout).to eq 120
      end
      example 'DBのレコード件数は増えない' do
        ApplicationSetting.create(application_name: "hello", expiration_of_session: "100")
        expect{ patch :update, application_setting: params_hash }.not_to change(ApplicationSetting, :count)
      end
    end

    context 'valid' do
      example 'invalidなら、editテンプレートを再レンダリング' do
        patch :update, application_setting: attributes_for(:application_setting,
          application_name: "", expiration_of_session: "-1")
        expect(response).to render_template :edit
      end
      example '例外ActionController::ParameterMissingが発生' do
        bypass_rescue
        expect { patch :update }.
          to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end