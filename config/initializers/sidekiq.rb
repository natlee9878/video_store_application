require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'Overdue Rental Reminder - Daily',
  cron: '* * * * *', # every midnight
  class: 'OverdueReminder'
)
