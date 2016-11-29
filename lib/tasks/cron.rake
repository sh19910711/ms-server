namespace :cron do
  task test: :environment do
    schedule = Whenever::Test::Schedule.new(file: 'config/schedule.rb')
    jobs = schedule.jobs[:runner]

    loop do
      jobs.each do |job|
        puts "==> running #{job[:task]}"
        instance_eval job[:task]
      end

      puts "==> run all cron jobs successfully, sleeping 60 seconds..."
      sleep 60
    end
  end
end
