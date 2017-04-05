module Crawling
  module Crawler
    extend self

    def execute(script)
      @logger = Logging::Logger.new(severity: script.log_level)
      @extraction = Extraction.create(script: script)
      @logger.debug('Extraction created', @extraction)
      begin
        try_execute(script)
      rescue Exception => e
        @logger.error(e.to_s, @extraction)
        puts e.to_s
      end
    end

    def try_execute(script)
      @agent = Mechanize.new
      @post = Postprocessing.new
      script_json = script.xpaths
      @parent_stack = []

      # exit when opening URL fails
      doc = try_get_url(@extraction, script_json['url'])
      return if doc.nil?

      instance = Instance.create(extraction_id: @extraction.id)
      instance.parent_id = instance.id

      data_row = script_json['data']

      iterate_json(data_row, doc, instance, script_json['url'], 'url')

      script.last_run = Time.now
      script.save!
      @extraction.execution_time = Time.now - @extraction.created_at
      puts Time.now
      puts @extraction.created_at
      @extraction.success = true
      @extraction.save!
      @logger.debug("Execution time: #{@extraction.execution_time}", @extraction)
    end

    def iterate_json(data_row, page, instance, parent_url, field_name)
      sleep(rand(1..5))


      ExtractionDatum.create(
          instance_id: instance.id, extraction_id: @extraction.id,
          field_name: field_name, value: parent_url
      ) unless parent_url.nil?

      data_row.each do |row|
        extraction_datum = ExtractionDatum.create(
            instance_id: instance.id, extraction_id: @extraction.id,
            field_name:  row['name'], value: extract_value(page, row)
        )
        @logger.debug(log_msg(extraction_datum, row), @extraction)
        create_extraction_data(instance, page, row)

        if @post.is_nested(row['postprocessing'])
          instance.is_leaf = false
          product_urls = @post.extract_attribute(page, row['xpath'], 'href')
          @parent_stack.push(instance.id)

          @logger.debug("Nested links: #{product_urls.size}", @extraction)

          product_urls.each do |url|
            nested_page = try_get_url(@extraction, url)
            next if nested_page.nil?

            new_instance = Instance.create(extraction_id: @extraction.id, parent_id: @parent_stack[-1])
            nested_row = row['postprocessing'][0]['data']

            iterate_json(nested_row, nested_page, new_instance, url, row['name'])
          end

          @parent_stack.pop

        elsif @post.is_restrict(row['postprocessing'])
          partial_htmls = page.parser.xpath(row['xpath'])
          @parent_stack.push(instance.id)

          @logger.debug("Restrict htmls: #{partial_htmls.size}", @extraction)

          partial_htmls.each do |html|
            restricted_page = mechanize_page(html)
            new_instance = Instance.create(extraction_id: @extraction.id, parent_id: @parent_stack[-1])
            nested_row = row['postprocessing'][0]['data']
            iterate_json(nested_row, restricted_page, new_instance, nil, row['name'])
          end

          @parent_stack.pop
        end
        
      end
      instance.save!
    end

    def create_extraction_data(instance, page, row)
      if @post.is_restrict(row['postprocessing'])
        puts "\n\n returning #{extract_value(page, row)}\n\n"
        return
      end

      extraction_datum = ExtractionDatum.create(
        instance_id: instance.id, extraction_id: @extraction.id,
        field_name:  row['name'], value: extract_value(page, row)
      )
      @logger.debug(log_msg(extraction_datum, row), @extraction)
    end

    def mechanize_page(html)
      Mechanize::Page.new(nil, { 'content-type' => 'text/html' }, html.to_s, nil, @agent)
    end

    def log_msg(extraction_datum, nested_row)
      "field: #{nested_row['name']}, xpath: #{nested_row['xpath']}, value: #{extraction_datum.value}"
    end

    def try_get_url(extraction, url)
      begin
        nested_page = @agent.get(url)
      rescue Exception => e
        @logger.error("#{e.to_s} url: #{url}", extraction)
        extraction.success = false
        extraction.save!
        nested_page = nil
      end
      nested_page
    end

    def extract_value(doc, row)
      #TODO: refactor postprocessing
      return @post.extract_attribute(doc, row['xpath'], 'href') if @post.is_nested(row['postprocessing'])
      return @post.extract_attribute(doc, row['xpath'], row['postprocessing'][0]['attribute']) if @post.attributes?(row['postprocessing'])
      value = @post.extract_text(doc, row['xpath'])
      return value.to_s.strip if @post.is_trim(row['postprocessing'])
      return value.to_s.gsub(/\s+/, '') if @post.is_whitespace(row['postprocessing'])
      value.to_s.strip
    end

    def try_html
      agent = Mechanize.new
      url = "https://www.alza.sk/notebooky/podla-vyuzitia/hracie/18848814.htm"
      # url = "https://www.alza.sk/pocitace/18852653.htm"
      page = agent.get(url)
      restrict = '//*[@id="boxes"]/div'
      xpath = '//*[@id="litp18852653"]/div[2]/ul[position() > 3]/li/span/a'
      # boxes = page.parser.xpath(restrict)
      # puts page.parser.xpath('//*[@id="litp18852653"]/div[2]/ul/li[position() < 4]/span/a')
      puts page.parser.xpath('//*[contains(@class, "categoryPageTitle")]/h1')
      puts page.parser.xpath('//*[@itemprop="name"]\h1')


      '//*[@id="boxes"]/div/div[1]/div/a'
      # restricted_page = Mechanize::Page.new(nil,{'content-type'=>'text/html'},boxes[1].to_s, nil,agent)
      # puts restricted_page.body
      # puts restricted_page.parser.xpath('//div[1]/div/div/text()')
      # '//*[@id="litp18852653"]/div[2]/ul[position() > 3]/li/span/a'
      # '//*[@id="boxes"]/div[5]/div[1]/div/div/text()
      # //*[@id="boxes"]/div[9]/div[1]/div/a
    end

  end
end
