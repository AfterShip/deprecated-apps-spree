require 'httpi'
require 'cgi'

class AftershipTracking < ActiveRecord::Base
  attr_accessible :tracking, :email, :order_number, :add_to_aftership_at

  def exec_add_to_aftership

    # Use em-http-request when available.
    if defined?(EventMachine::HttpRequest)
      HTTPI.adapter = :em_http
    end

    begin

      post_data = {"api_key" => Spree::Aftership::Config[:api_key], "tracking_number" => tracking, "emails" => [email], "source" => "Spree Order: #{order_number}", "title" => order_number}

      request = HTTPI::Request.new("https://api.aftership.com/v1/trackings")
      request.body = post_body_from_hash(post_data)
      response = HTTPI.post(request)


      if response.code == 201
        logger.info "Tracking added to AfterShip"
        self.update_attributes(:add_to_aftership_at => Time.now)
      elsif response.code == 422
        logger.error "AfterShip responded with Unprocessable Entity, most likely unsupported tracking numbers"
        self.update_attributes(:add_to_aftership_at => Time.now)
      else
        logger.error "Unable to add tracking number to AfterShip! Response Code: #{response.code}"
      end


    rescue Exception => e
      logger.error "AfterShip Error #{e.message}"
      logger.error "#{e.backtrace}"
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

  private

  def post_body_from_hash(post_data)
    if post_data.is_a?(Hash)
      return post_data.map { |k, v|
        if v.instance_of?(Array)
          v.map { |e| "#{CGI.escape(k.to_s)}[]=#{CGI.escape(e.to_s)}" }.join("&")
        else
          "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
        end
      }.join("&")
    end
    nil
  end

end