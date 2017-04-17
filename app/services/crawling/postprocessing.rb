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

      return type_check(parsed_text, type)

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

    def type_check data, type
      case type
        when 'integer'
          puts "Integer uprava pre " + data.to_s
          data = (data.to_s).gsub(/[[:space:]]/, '')
          puts data.to_s
          data = data.match('[-+]?[0-9]*\.?[0-9]+')
          puts "VYSLEDOK: " + data.to_s
      end

      return data
    end

  end
end