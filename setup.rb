require 'httparty'
require 'securerandom'
require 'openssl'
require 'base64'
require 'socket'

ALPHABET = "_-~.#{('a'..'z').to_a.join}#{('A'..'Z').to_a.join}#{(0..9).to_a.join}".chars.freeze
CODE_LENGTH = 128

def random_code(alphabet, length)
  length.times.map { alphabet.sample }.join
end

def send_challenge(ip_address, code_verifier)
  challenge = Base64.urlsafe_encode64(OpenSSL::Digest::SHA256.digest(code_verifier)).chomp("=")
  auth_url = "https://#{ip_address}:8443/v1/oauth/authorize"
  params = {
    audience: "homesmart.local",
    response_type: "code",
    code_challenge: challenge,
    code_challenge_method: "S256"
  }
  response = HTTParty.get(auth_url, query: params, verify: false, timeout: 10)
  raise "Request failed with status #{response.code}" unless response.success?

  response.parsed_response["code"]
end

def get_token(ip_address, code, code_verifier)
  response = HTTParty.post(
    "https://#{ip_address}:8443/v1/oauth/token",
    body: URI.encode_www_form(
      code: code,
      name: Socket.gethostname,
      grant_type: "authorization_code",
      code_verifier: code_verifier
    ),
    headers: { "Content-Type" => "application/x-www-form-urlencoded" },
    verify: false,
    timeout: 10
  )
  raise "Request failed with status #{response.code}" unless response.success?

  response.parsed_response["access_token"]
end

def main
  ip_address = ARGV.length > 0 ? ARGV[0] : (puts "Input the IP address of your Dirigera then hit ENTER ..."; gets.chomp)
  code_verifier = random_code(ALPHABET, CODE_LENGTH)
  code = send_challenge(ip_address, code_verifier)
  puts "Press the action button on Dirigera then hit ENTER ..."
  gets
  token = get_token(ip_address, code, code_verifier)
  puts "Your token:"
  puts token
end

main
