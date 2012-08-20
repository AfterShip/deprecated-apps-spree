Spree::Shipment.class_eval do

  after_save :send_tracking_to_aftership

  private

  def send_tracking_to_aftership
    if tracking && tracking_changed?

      AftershipTracking.create(:tracking => tracking, :email => order.email, :order_number => order.number).add_to_aftership

      # this piece of code introduce massive performance bottleneck when a tracking is not included

      # AftershipTracking.add_to_aftership
    end
  end

end