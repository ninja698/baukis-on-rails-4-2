module ApplicationHelper
  include HtmlBuilder

  def document_title
    if @title.present?
      "#{@title} - #{acquire_title}"
    else
      acquire_title
    end
  end

  def acquire_title
    if ApplicationSetting.exists?
      ApplicationSetting.first.application_name
    else
      "Baukis"
    end
  end

end
