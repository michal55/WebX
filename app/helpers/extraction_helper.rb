module ExtractionHelper
  def format_time seconds
    if seconds.nil?
      ''
    elsif seconds < 1
      Time.at(seconds).utc.strftime("%-Lms")
    else
      Time.at(seconds).utc.strftime("%-Ss %-Lms")
    end
  end

  def status status
    return 'succes' if status
    'fail'
  end

  def color status
    return 'limegreen' if status
    'red'
  end
end
