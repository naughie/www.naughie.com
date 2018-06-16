class Certificates
  ENDPOINTS = {
    'production'  => 'https://acme-v02.api.letsencrypt.org/directory',
    'development' => 'https://acme-staging-v02.api.letsencrypt.org/directory',
    'test'        => 'https://acme-staging-v02.api.letsencrypt.org/directory'
  }.freeze

  ADMIN_EMAIL = "zomacchi@gmail.com".freeze
  DOMAIN = 'naughie.net'.freeze

  FileUtils.mkdir_p Rails.root.join('.certificates', 'certificates')
  FileUtils.mkdir_p Rails.root.join('.certificates', 'private_keys')
  FileUtils.mkdir_p Rails.root.join('.certificates', 'challenges')

  def self.fetch
    client = Acme::Client.new private_key: generate_private_key, directory: ENDPOINTS[Rails.env]
    account = client.new_account contact: "mailto:#{ADMIN_EMAIL}", terms_of_service_agreed: true
    order = client.new_order identifiers: [DOMAIN]
    authorization = order.authorizations.first
    challenge = authorization.http
    save_challenge challenge.token, challenge.file_content
    challenge.request_validation
    while challenge.status == 'pending'
      sleep 2
      challenge.reload
    end
    csr_private_key = generate_private_key
    csr = Acme::Client::CertificateRequest.new private_key: csr_private_key, subject: { common_name: DOMAIN }
    order.finalize csr: csr
    sleep 1 while order.status == 'processing'
    save_certificate order.certificate, csr_private_key
  end

  def self.generate_private_key
    OpenSSL::PKey::RSA.new 4096
  end

  def self.save_challenge token, contents
    File.write Rails.root.join('.certificates/challenges', token), contents
  end

  def self.save_certificate certificate, private_key
    File.write Rails.root.join('.certificates/certificates', "#{DOMAIN}.crt"), certificate
    File.write Rails.root.join('.certificates/private_keys', "#{DOMAIN}.key"), private_key
  end

  def self.clear_challenges
    Dir.each_child Rails.root.join('.certificates/challenges') do |f|
      File.delete f
    end
  end
end
