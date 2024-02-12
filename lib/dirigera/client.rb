require 'httparty'

class Dirigera::Client
  def initialize(ip, bearer_token)
    @ip = ip
    @bearer_token = bearer_token
  end

  def blinds
    devices.select { |data| data['type'] == 'blinds' }.map { |data| make_device(data) }
  end

  def outlets
    devices.select { |data| data['type'] == 'outlet' }.map { |data| make_device(data) }
  end

  def lights
    devices.select { |data| data['type'] == 'light' }.map { |data| make_device(data) }
  end

  def devices
    get("/devices")
  end

  def get(path, params = {})
    HTTParty.get(
      "#{base_url}#{path}",
      query: params,
      headers: headers,
      verify: false
    )
  end

  def patch(path, data)
    HTTParty.patch(
      "#{base_url}#{path}",
      body: data.to_json,
      headers: headers,
      verify: false
    )
  end

  private

  def make_device(data)
    Object.const_get("Dirigera::#{data['deviceType'].capitalize}").new(data, self)
  rescue NameError
    Dirigera::Device.new(data, self)
  end

  def headers
    {
      'Authorization': "Bearer #{@bearer_token}",
      "Content-Type": 'application/json'
    }
  end

  def base_url
    "https://#{@ip}:8443/v1"
  end
end
