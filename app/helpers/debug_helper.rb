module DebugHelper

  def example_script
    {
        "url"=>"http://stackoverflow.com/questions",
        "data"=>[
           {
               "name"=>"block",
               "xpath"=>"//div[@class='question-summary']",
               "postprocessing"=>[
                   {
                       "type"=>"restrict",
                       "data"=>[
                           {
                               "name"=>"views",
                               "xpath"=>"//div[@class='views ']"
                           },
                           {
                               "name"=>"title",
                               "xpath"=>"//a[@class='question-hyperlink']"
                           },
                           {
                               "name"=>"question_link",
                               "xpath"=>"//a[@class='question-hyperlink']",
                               "postprocessing"=>[
                                   {
                                       "type"=>"nested",
                                       "data"=>[
                                           {
                                               "name"=>"question_body",
                                               "xpath"=>"//div[@class='post-text']"
                                           }
                                       ]
                                   }
                               ]
                           },
                           {
                               "name"=>"next_page",
                               "xpath"=>"//*[@rel='next']",
                               "postprocessing"=>[
                                   {
                                       "type"=>"pagination",
                                       "limit"=>4
                                   }
                               ]
                           }
                       ]
                   }
               ]
           }
        ]
      }
  end


end
