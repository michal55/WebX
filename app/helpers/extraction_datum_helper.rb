module ExtractionDatumHelper
  include ExtractionDatumMapper
  def make_array(instance, fields_array)
    ExtractionDatumMapper.make_row(instance, fields_array)
  end

  def csv_row(array)
    array.to_csv(row_sep: nil).html_safe
  end

  def get_all_leafs extraction_id
    Instance.where(extraction_id: extraction_id).where(is_leaf: true).order('id ASC')
  end

end
