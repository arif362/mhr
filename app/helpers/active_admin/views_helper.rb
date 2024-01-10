module ActiveAdmin::ViewsHelper

  def country_name(object)
    if object.country.present?
      object_country = ISO3166::Country[object.country]
      object_country.translations[I18n.locale.to_s] || object_country.name
    else
      ''
    end
  end

end