class Certificates
  ENDPOINTS = {
    'production'  => 'https://acme-v02.api.letsencrypt.org/directory',
    'development' => 'https://acme-staging-v02.api.letsencrypt.org/directory',
    'test'        => 'https://acme-staging-v02.api.letsencrypt.org/directory'
  }.freeze

  ADMIN_EMAIL = "#{Rails.application.secrets.gmail[:user]}@gmail.com".freeze
  DOMAIN = 'naughie.net'.freeze

  FileUtils.mkdir_p Rails.root.join('.certificates', 'certificates')
  FileUtils.mkdir_p Rails.root.join('.certificates', 'private_keys')
  FileUtils.mkdir_p Rails.root.join('.certificates', 'certs_chains')
  FileUtils.mkdir_p Rails.root.join('.certificates', 'challenges')

  def self.fetch
    client = acme_client generate_private_key
    authorization = authorize client
    challenge = set_challenge_with authorization
    certificate = verify_domain_and_get_certificate client, challenge
    save_certificate certificate
    clear_challenges
  end

  def self.acme_client private_key
    Acme::Client.new private_key: private_key, endpoint: ENDPOINTS[Rails.env], connection_options: { request: { open_timeout: 5, timeout: 5 } }
  end

  def self.generate_private_key
    OpenSSL::PKey::RSA.new 2048
  end

  def self.authorize client
    registration = client.register contact: "mailto:#{ADMIN_EMAIL}"
    registration.agree_terms
    client.authorize domain: DOMAIN
  end

  def self.set_challenge_with authorization
    challenge = authorization.http01
    save_challenge challenge.token, challenge.file_content
    challenge
  end

  def self.verify_domain_and_get_certificate client, authorization, challenge
    challenge.request_verification
    if challenge.authorization.verify_status == 'valid'
      csr = Acme::Client::CertificateRequest.new names: [DOMAIN]
      certificate = client.new_certificate csr
      {
        certificate: certificate.to_pem,
        private_key: certificate.request.private_key.to_pem,
        certs_chain: certificate.chain_to_pem,
      }
    else
      raise CertifateError
    end
  end

  def self.save_challenge token, contents
    File.write Rails.root.join('.certificates/challenges', token), contents
  end

  def self.save_certificate certificate
    File.write Rails.root.join('.certificates/certificates', "#{DOMAIN}.crt"), certificate[:certificate]
    File.write Rails.root.join('.certificates/private_keys', "#{DOMAIN}.key"), certificate[:private_key]
    File.write Rails.root.join('.certificates/certs_chains', "#{DOMAIN}.crt"), certificate[:certs_chain]
  end

  def self.clear_challenges
    Dir.each_child Rails.root.join('.certificates/challenges') do |f|
      File.delete f
    end
  end
end
