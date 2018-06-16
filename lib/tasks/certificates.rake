namespace :certificates do
  desc 'Fetch certificate'
  task :fetch do
    Certificates.fetch
  end
end
