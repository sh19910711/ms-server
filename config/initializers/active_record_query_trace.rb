if Rails.env.development? or Rails.env.test?
  ActiveRecordQueryTrace.enabled = true
end
