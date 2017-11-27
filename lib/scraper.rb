require 'open-uri'
require 'pry'

class Scraper

  #Students: doc.css(".roster-cards-container div.student-card")
  #Name: student.css("h4").text
  #Location: student.css("p").text
  #URL: student.css("a").attribute("href").value

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = []
    students_array = doc.css(".roster-cards-container div.student-card")
    students_array.each do |student|
      name = student.css("h4").text
      location = student.css("p").text
      url = student.css("a").attribute("href").value
      profile_url = "http://138.68.11.226:30006/fixtures/student-site/" + url
      student_hash = {:name => name, :location => location, :profile_url => profile_url}
      students << student_hash
    end
    students
  end

  #Networks: doc.css("div.social-icon-container a")
  #Twitter: networks[0].attribute("href").value
  #LinkedIn: networks[1].attribute("href").value
  #Github: networks[2].attribute("href").value
  #Blog: networks[3].attribute("href").value
  #ProfileQuote: doc.css("div.vitals-text-container div.profile-quote").text
  #Bio: doc.css("div.bio-content div.description-holder p").text

  def self.scrape_profile_page(profile_url)
    begin
    html = open(profile_url)
    rescue OpenURI::HTTPError
      puts "Error opening page"
    end


    doc = Nokogiri::HTML(html)
    student_hash = {}
    networks = doc.css("div.social-icon-container a")
    networks.each do |network|
      social = network.attribute("href").value
      if social.include?("twitter")
        student_hash[:twitter] = social
      elsif social.include?("linkedin")
        student_hash[:linkedin] = social
      elsif social.include?("github")
        student_hash[:github] = social
      else
        student_hash[:blog] = social
      end
    end
    student_hash[:profile_quote] = doc.css("div.vitals-text-container div.profile-quote").text
    student_hash[:bio] = doc.css("div.bio-content div.description-holder p").text
    student_hash
  end

end
