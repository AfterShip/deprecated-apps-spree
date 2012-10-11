require 'uri'
require 'net/http'
require 'net/https'
require 'cgi'

class AftershipTracking < ActiveRecord::Base
  attr_accessible :tracking, :email, :order_number, :add_to_aftership

  def exec_add_to_aftership
    post_data = {"api_key" => Spree::Aftership::Config[:api_key], "tracking_number" => tracking, "emails" => [email], "source" => "Spree Order: #{order_number}","title"=>"#{order_number}"}
    begin
      url = URI.parse("https://api.aftership.com/v1/trackings")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data(post_data)

      sock = Net::HTTP.new(url.host, url.port)
      sock.use_ssl = true
      res = sock.start { |http| http.request(req) }

      case res
        when Net::HTTPOK
          tracking.update_attribute(:add_to_aftership, Time.now)
        else
          logger.error "Unable to add tracking number to AfterShip! #{res.inspect}"
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
    AftershipTracking.where(:add_to_aftership => nil).each do |tracking|
      tracking.add_to_aftership
    end
    AftershipTracking.where("add_to_aftership <= ?", 1.month.ago).destroy_all
  end
end