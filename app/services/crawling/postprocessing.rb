module Crawling
  class Postprocessing

    def is_whitespace(row)
      row.is_a?(Array) and row.size > 0 and row[0]['type'] == "whitespace"
    end

    def is_trim(row)
      row.is_a?(Array) and row.size > 0 and row[0]['type'] == "trim"
    end

    def is_nested(row)
      #TODO: kontrola na array nemusi byt idealna, uvidime co do toho jsonu este pribudne
      row.is_a?(Array) and row.size > 0 and row[0]['type'] == "nested"
    end

    def is_restrict(row)
      row.is_a?(Array) and row.size > 0 and row[0]['type'] == "restrict"
    end

    def pagination(data_row, arg)
      data_row.each do |row|
        next if row['postprocessing'].nil?
        if row['postprocessing'][0]['type'] == "pagination"
          return row['xpath'] if arg.eql?("xpath")
          if arg.eql?("limit")
            return row['postprocessing'][0]['limit'].nil? ? 0 : row['postprocessing'][0]['limit']
          end
        end
      end
      nil
    end

    def decr_page_limit(data_row)
      data_row.map! do |row|
        if row['postprocessing'].nil?
          row
        elsif row['postprocessing'][0]['type'] == "pagination"
          row['postprocessing'][0]['limit'] -= 1
          row
        else
          row
        end
      end
      data_row
    end

    def extract_text doc, xpath
      if xpath[-7..-1].eql?("/text()")
        doc.parser.xpath(xpath)
      else
        doc.parser.xpath "#{xpath}//text()"
      end
    end

    def extract_attribute doc, xpath, attribute
      result = []
      links = doc.parser.xpath(xpath)
      # when link has to be extracted differently, not from href attribute of <a> element
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

    def attributes? row
      row.is_a?(Array) and row.size > 0 and row[0]['type'] == 'attribute'
    end

  end
end