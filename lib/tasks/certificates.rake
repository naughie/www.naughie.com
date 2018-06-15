require File.expand_path('../../certificates.rb', __FILE__)

namespace :certificates do
  desc 'Fetch certificate'
  task :fetch do
    Certificates.fetch
  end
end
