class CertificatesController < ApplicationController
  def show
    challenge = File.read Rails.root.join('.certificates/challenges', params[:filename])
    render layout: false, content_type: 'text/plain', plain: challenge
  end
end
