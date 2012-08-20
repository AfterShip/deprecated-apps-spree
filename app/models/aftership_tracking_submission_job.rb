class AftershipTrackingSubmissionJob < Struct.new(:id)
  def perform
    AftershipTracking.find(self.id).exec_add_to_aftership
  end
end