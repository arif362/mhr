module ProvidentFundHelper
  def link_to_add_policy(name, form, association, options = {})
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', builder: builder)
    end
    link_to '#', class: "#{options[:klass]}", data: {id: id, fields: fields.gsub('\n', '')} do
      raw "<i class='fa fa-plus-circle'></i> #{name}"
    end
  end
end
