module Crawling
  class Postprocessing

    def strip_whitespace(row)
      row.is_a?(Array) and row.size > 0 and row[0]['type'] == "whitespace"
    end

    def is_nested(row)
      #TODO: kontrola na array nemusi byt idealna, uvidime co do toho jsonu este pribudne
      row.is_a?(Array) and row.size > 0 and row[0]['type'] == "nested"
    end

    def extract_text doc, xpath
      if xpath[-7..-1].eql?("/text()")
        doc.parser.xpath(xpath)
      else
        doc.parser.xpath "#{xpath}/text()"
      end
    end

    def extract_href doc, xpath
      result = []
      doc.parser.xpath(xpath).each do |link|
        result.push(link.attributes['href'].to_s)
      end
      puts result
      result
    end

  end
end