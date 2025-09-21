module Helpers::Tags
  def dom_id(record)
    "#{Inflector.dasherize(Inflector.singularize(record.model.table_name))}-#{record.id}"
  end

  def component instance, &block
    instance.call(context: { app: self }, &block)
  end
end
