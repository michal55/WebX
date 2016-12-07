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

  def status status
    return t('extractions.success') if status
    t('extractions.fail')
  end

  def color status
    return 'limegreen' if status
    'red'
  end
end
