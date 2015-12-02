require 'rails_helper'

describe ApplicationSetting do
  describe 'バリデーション' do
    let(:setting) { build(:application_setting) }
    example 'そもそも、ファクトリの入力値が有効であること' do
      expect(setting).to be_valid
    end
    example 'application_nameが空白ならば無効' do
      setting.application_name = ""
      setting.valid?
      expect(setting.errors[:application_name]).to include("が入力されていません。")
    end
    example 'application_nameが17文字ならば無効' do
      setting.application_name =  "a" * 17
      setting.valid?
      expect(setting.errors[:application_name]).to include("は16文字以内で入力してください。")
    end
    example "expiration_of_sessionが負の数ならば無効" do
      setting.expiration_of_session = "-1"
      setting.valid?
      expect(setting.errors[:expiration_of_session]).to include("は0以上の値にしてください。")
    end
    example "expiration_of_sessionが数値でなければ無効" do
      setting.expiration_of_session = "a"
      setting.valid?
      expect(setting.errors[:expiration_of_session]).to include("は数値で入力してください。")
      setting.expiration_of_session = "１．１"
      setting.valid?
      expect(setting.errors[:expiration_of_session]).to include("は数値で入力してください。")
    end
  end
end
