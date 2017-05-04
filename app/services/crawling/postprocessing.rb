module Crawling
  class Postprocessing

    def is_postprocessing(row, type)
      return false if row['postprocessing'].nil? or !row['postprocessing'].is_a?(Array)
      row['postprocessing'].each do |post|
        return true if post['type'] == type
      end
      false
    end

    def postprocessing_data(row, type, data)
      return nil if row['postprocessing'].nil? or !row['postprocessing'].is_a?(Array)
      row['postprocessing'].each do |post|
        if post['type'] == type
          return post[data]
        end
      end
    end

    def is_pagination(data_row)
      # data_row can be a simple json hash or an array of json hashes
      # entire data_row has to be iterated through to check if pagination postprocessing is present

      if !data_row.is_a?(Array)
        return is_postprocessing(data_row, 'pagination')
      else
        data_row.each do |row|
          return true if is_postprocessing(row, 'pagination')
        end
      end
      false
    end

    def pagination(data_row, arg)
      data_row.each do |row|
        next if row['postprocessing'].nil? or row['postprocessing'].size == 0 or !is_postprocessing(row, 'pagination')
        return row['xpath'] if arg.eql?("xpath")
        return postprocessing_data(row,'pagination','limit').nil? ? 0 : postprocessing_data(row,'pagination','limit') if arg.eql?("limit")
      end
      nil
    end

    def login_row(data_row)
      data_row.each do |row|
        next if row['postprocessing'].nil? or row['postprocessing'].size == 0 or !is_postprocessing(row, 'post')
        return row
      end
      nil
    end
    
    def extract_text doc, type, xpath
      if xpath[-7..-1].eql?("/text()")
        parsed_text = doc.parser.xpath(xpath)
      else
        parsed_text = doc.parser.xpath "#{xpath}//text()"
      end
      type_check(parsed_text, type, doc)
    end

    def extract_attribute doc, xpath, attribute
      result = []
      links = doc.parser.xpath(xpath)
      # when link has to be extracted differently, not from href attribute of <a> element
      # i.e. onclick() function
      # TODO: may need fixing
      if links.is_a?(String)
        result.push(links)
        return result
      end

      links.each do |link|
        result.push(link.attributes[attribute].to_s)
      end
      result
    end

    def attribute row
      return "" if row['postprocessing'].nil?
      row['postprocessing'][0]['attribute']
    end

    def type_check data, type, page
      new_data = nil
      if data.is_a?(Array)
        new_data = []
        data.each do |d|
          case type
          when 'integer'
            new_data << type_integer(d.to_s)
          when 'float'
            new_data << type_float(d.to_s)
          when 'link'
            new_data << type_link(d, page)
          when 'date'
            begin
              new_data = type_date(data.to_s)
            rescue Exception => e
              new_data = ""
              raise e
            end
          else
            new_data << d.to_s
          end
        end
      else
        case type
        when 'integer'
          new_data = type_integer(data.to_s)
        when 'float'
          new_data = type_float(data.to_s)
        when 'link'
          new_data = type_link(data, page)
        when 'date'
          begin
            new_data = type_date(data.to_s)
          rescue Exception => e
            new_data = ""
            raise e
          end
        else
          new_data = data.to_s
        end
      end
      new_data

    end

    def type_link(data, page)
      return data if data[0..3].eql?('http')
      domain_url = page.uri.to_s
      arr        = domain_url.split('/')
      domain_url = arr[0] + "//" + arr[2]
      domain_url + data.to_s
    end

    def type_float(new_data)
      Monetize.parse("USD" + regex_number(new_data)).to_f.to_s
    end

    def type_integer(new_data)
      Monetize.parse("USD" + regex_number(new_data)).to_i.to_s
    end

    def type_date(new_data)
      begin
        Date.parse(new_data).strftime('%F')
      rescue Exception => e
        raise e
      end
    end

    def regex_number(input)
      input.gsub(/[[:space:]]/, '').match(/[+-]?([0-9]+)([.,][0-9]+)*/).to_s
    end

    def filter row, date, greater
      filter_date = postprocessing_data(row, 'filter', 'filter')
      case filter_date
      when 'yesterday-or-older'
        if greater
          return date > yesterday
        else
          return false
        end
      when 'yesterday'
        if greater
          return date > yesterday
        else
          return date < yesterday
        end
      when 'before-yesterday'
        if greater
          return date > before_yesterday
        else
          return date < before_yesterday
        end

      end
    end

    def today
      Time.now.strftime("%Y-%m-%d").to_date
    end

    def yesterday
      Time.now.strftime("%Y-%m-%d").to_date - 1.day
    end

    def before_yesterday
      Time.now.strftime("%Y-%m-%d").to_date - 2.day
    end

  end
end