require 'uri'
require 'net/http'
require 'net/https'
require 'cgi'

Spree::Shipment.class_eval do

  after_save :send_tracking_to_aftership

  private

  def send_tracking_to_aftership
    if tracking && tracking_changed?
      post_data = {"consumer_key" => Spree::Aftership::Config[:consumer_key], "consumer_secret" => Spree::Aftership::Config[:consumer_secret], "tracking_number" => tracking, "email"=> order.email, "title" => "#{Spree::Config.site_name} Order: #{order.number}"}

      url = URI.parse("https://www.aftership.com/en/api/add-tracking/")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data(post_data)

      sock = Net::HTTP.new(url.host, url.port)
      sock.use_ssl = true
      res = sock.start {|http| http.request(req) }

    end
  end

end