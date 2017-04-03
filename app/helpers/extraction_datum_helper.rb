module ExtractionDatumHelper
  include ExtractionDatumMapper
  def make_array(instance, fields_array)
    ExtractionDatumMapper.make_row(instance, fields_array)
  end

  def csv_row(array)
    array.to_csv(row_sep: nil).html_safe
  end

end
