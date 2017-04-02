module ExtractionHelper
  def format_time seconds
    if seconds.nil?
      ''
    elsif seconds < 1
      Time.at(seconds).utc.strftime("%-Lms").to_s.sub(/^[0]*/,"")
    else
      result = ""
      Time.at(seconds).utc.strftime("%-Ss %-Lms").to_s.split(' ').each do |s|
        result += s.sub(/^[0]*/," ")
      end
      result
    end
  end

  def extraction_status status
    return t('extractions.success') if status
    t('extractions.fail')
  end

  def find_class status
    return 'extraction-success' if status
    'extraction-fail'
  end

  def instance_count extraction
    Instance.where(extraction_id: extraction.id).count
  end

  def empty_fields_count extraction
    ExtractionDatum.where(extraction_id: extraction.id).where(value: '').count
  end

  def empty_fields_per_field_count data_field, extraction
    ExtractionDatum.where(extraction_id: extraction.id).where(value: '').where(field_name: data_field.name).count
  end
end
