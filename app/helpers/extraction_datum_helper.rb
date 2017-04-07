module ExtractionDatumHelper
  include ExtractionDatumMapper
  def make_array(instance, fields_array)
    ExtractionDatumMapper.make_row(instance, fields_array)
  end


end
