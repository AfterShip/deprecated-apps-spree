require 'uri'
require 'net/http'
require 'net/https'
require 'cgi'

class AftershipTracking < ActiveRecord::Base
  attr_accessible :tracking, :email, :order_number, :add_to_aftership

  def self.add_to_aftership
    AftershipTracking.where(:add_to_aftership => nil).each do |tracking|
      post_data = {"api_key" => Spree::Aftership::Config[:api_key], "tracking_number" => tracking.tracking, "email" => tracking.email, "source" => "Spree Order: #{tracking.order_number}","title"=>"#{tracking.order_number}"}

      begin
        url = URI.parse("https://www.aftership.com/en/api/add-tracking/")
        req = Net::HTTP::Post.new(url.path)
        req.set_form_data(post_data)

        sock = Net::HTTP.new(url.host, url.port)
        sock.use_ssl = true
        res = sock.start { |http| http.request(req) }

        case res
          when Net::HTTPOK
            tracking.update_attribute(:add_to_aftership, Time.now)
          else
            logger.error 'Unable to add tracking number to AfterShip!'
        end
      rescue Exception => e
        logger.error "AfterShip error:#{e.message}"
      end
    end
    AftershipTracking.where("add_to_aftership <= ?", 1.month.ago).destroy_all

  end
end