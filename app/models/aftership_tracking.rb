require 'uri'
require 'net/http'
require 'net/https'
require 'cgi'

class AftershipTracking < ActiveRecord::Base
  attr_accessible :tracking, :email, :order_number, :add_to_aftership_at

  def exec_add_to_aftership
    post_data = {"api_key" => Spree::Aftership::Config[:api_key], "tracking_number" => tracking, "emails" => [email], "source" => "Spree Order: #{order_number}", "title" => "#{order_number}"}
    begin
      url = URI.parse("https://api.aftership.com/v1/trackings")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data(post_data)

      sock = Net::HTTP.new(url.host, url.port)
      sock.use_ssl = true
      res = sock.start { |http| http.request(req) }

      if res.is_a?(Net::HTTPCreated)
        logger.info "Tracking added to AfterShip"
        self.update_attributes(:add_to_aftership_at => Time.now)
      elsif  res.is_a?(Net::HTTPClientError)
        if res.code == "422"
          logger.error "AfterShip responded with Unprocessable Entity, most likely unsupported tracking numbers"
          self.update_attributes(:add_to_aftership_at => Time.now)
        end
      else
        logger.error "Unable to add tracking number to AfterShip!"
      end
    rescue Exception => e
      logger.error "AfterShip error:#{e.message}"
    end
  end

  def add_to_aftership
    if defined?(Delayed::Job)
      Delayed::Job.enqueue(AftershipTrackingSubmissionJob.new(self.id))
    else
      self.exec_add_to_aftership
    end
  end

  def self.add_to_aftership
    AftershipTracking.where(:add_to_aftership_at => nil).each do |tracking|
      tracking.add_to_aftership
    end
    AftershipTracking.where("add_to_aftership_at <= ?", 1.month.ago).destroy_all
  end
end