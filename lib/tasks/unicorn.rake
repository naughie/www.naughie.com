require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :unicorn do
  desc 'Start unicorn'
  task(:start) {
    %x(bundle exec unicorn_rails -c #{unicorn_config} -E #{rails_env} -D)
  }

  desc 'Stop unicorn'
  task(:stop) { unicorn_signal :QUIT }

  desc 'Restart unicorn with USR2'
  task(:restart) { unicorn_signal :USR2 }

  desc 'Increment number of worker processes'
  task(:increment) { unicorn_signal :TTIN }

  desc 'Decrement number of worker processes'
  task(:decrement) { unicorn_signal :TTOU }

  desc 'Unicorn pstree (depends on pstree command)'
  task(:pstree) do
    %x(pstree '#{unicorn_pid}')
  end

  def unicorn_signal signal
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      File.read("#{rails_root}/tmp/pids/unicorn.pid").to_i
    rescue Errno::ENOENT
      raise "Unicorn doesn't seem to be running"
    end
  end

  def rails_root
    require 'pathname'
    Pathname.new(__FILE__) + '../'
  end

  def rails_env
    ENV['RAILS_ENV'] || :development
  end

  def unicorn_config
    "#{rails_root}/config/unicorn.rb"
  end
end
