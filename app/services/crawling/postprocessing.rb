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

    def extract_text doc, xpath
      if xpath[-7..-1].eql?("/text()")
        doc.parser.xpath(xpath)
      else
        doc.parser.xpath "#{xpath}//text()"
      end
    end

    def extract_attribute doc, xpath, attribute
      result = []
      doc.parser.xpath(xpath).each do |link|
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