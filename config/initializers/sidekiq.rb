require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'Overdue Rental Reminder - Daily',
  cron: '0 0 * * *', # every midnight
  class: 'OverdueReminder'
)
