every 5.minutes do
   runner "UpdateDeviceStatusJob.perform_now"
end
