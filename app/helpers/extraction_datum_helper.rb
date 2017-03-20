module ExtractionDatumHelper
  def make_array(instance, fields_array)
    extaction_data = instance.extraction_data
    array = Array.new(fields_array.size,'-')
    extaction_data.each do |ext|
      array[fields_array.index(ext.field_name)] = ext.value
    end
    array
  end

end
