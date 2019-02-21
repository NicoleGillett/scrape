require 'kimurai'

class GithubSpider < Kimurai::Base
  @name = "scrape"
  @engine = :selenium_chrome
  @start_urls = ["https://register.fca.org.uk/directory/s/"]
  @config = {
    user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
    before_request: { delay: 4..7 }
  }

  def parse(response, url:, data: {})
    browser.fill_in "input-8", with: "HA4"
    browser.click_button "SEARCH"

    # Update response to current response after interaction with a browser
    response = browser.current_response

    # Collect results
    results = response.xpath("//*[@id="ResultSection"]/div[3]/div[1]/div/div[1]/div[1]/div[1]/a").map do |a|
      { title: a.text, url: a[:href] }
    end
