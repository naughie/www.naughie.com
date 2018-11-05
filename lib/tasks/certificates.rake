namespace :certificates do
  desc 'Fetch certificate'
  task fetch: :environment do
    Certificates.fetch
  end
end
