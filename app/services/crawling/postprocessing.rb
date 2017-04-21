module Crawling
  class Postprocessing

    #TODO: still only one postprocessing
    def is_postprocessing(row, type)
      return false if row['postprocessing'].nil?
      row = row['postprocessing']

      row.is_a?(Array) and row.size > 0 and row[0]['type'] == type
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
        next if row['postprocessing'].nil? or row['postprocessing'].size == 0
        if row['postprocessing'][0]['type'] == "pagination"
          return row['xpath'] if arg.eql?("xpath")
          if arg.eql?("limit")
            return row['postprocessing'][0]['limit'].nil? ? 0 : row['postprocessing'][0]['limit']
          end
        end
      end
      nil
    end

    def extract_text doc, type, xpath #pridat volania metod na kontrolu datovych typov
      if xpath[-7..-1].eql?("/text()")
        parsed_text = doc.parser.xpath(xpath)
      else
        parsed_text = doc.parser.xpath "#{xpath}//text()"
      end

      return type_check(parsed_text, type, doc)

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
      puts result
      result
    end

    def attribute row
      return "" if row['postprocessing'].nil?
      row['postprocessing'][0]['attribute']
    end

    def type_check data, type, page
      new_data = data.to_s
      case type
        when 'integer'
          new_data = (new_data.gsub(/[[:space:]]/, '')).match(/\d+/)
          new_data = ((new_data.to_s).to_i).to_s
        when 'float'
          new_data = (new_data.gsub(/[[:space:]]/, '')).match(/[+-]?([0-9]+)([.,][0-9]+)?/)
          new_data = ((new_data.to_s).to_f).to_s
        when 'link'
          domain = page.uri.to_s
          arr = domain.split('/')
          domain = arr[0] + "//" + arr[2]


          data.collect!  do |d|
            domain + d.to_s
          end
          return data
      end

      return new_data
    end

  end
end