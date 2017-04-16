module ExtractionHelper
  def format_time seconds
    format = ""
    if seconds.nil?
      return ''
    elsif seconds < 1
      format = "%-Lms"
    elsif seconds < 60
      format = "%-Ss %-Lms"
    elsif seconds < 3600
      format = "%-Mm %-Ss"
    else
      format = "%-Hh %-Mm"
    end
    Time.at(seconds).utc.strftime(format)
  end

  def extraction_status status
    return t('extractions.success') if status
    return t('extractions.running') if status.nil?
    t('extractions.fail')
  end

  def find_class status
    return 'extraction-success' if status
    return 'extraction-running' if status.nil?
    'extraction-fail'
  end

  def instance_count extraction
    Instance.where(extraction_id: extraction.id, is_leaf: true).count
  end

  def empty_fields_count extraction
    ExtractionDatum.where(extraction_id: extraction.id).where(value: '').count
  end

  def empty_fields_per_field_count data_field, extraction
    ExtractionDatum.where(extraction_id: extraction.id).where(value: '').where(field_name: data_field.name).count
  end
end
