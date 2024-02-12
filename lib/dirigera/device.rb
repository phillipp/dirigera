class Dirigera::Device
  def initialize(data, client)
    @data = data
    @client = client
  end

  attr_reader :client

  def id
    @data['id']
  end

  def type
    @data['type']
  end

  def name
    @data['attributes']['customName']
  end

  def created_at
    Time.parse(@data['createdAt'])
  end

  def last_seen_at
    Time.parse(@data['lastSeen'])
  end

  def battery_level
    @data['attributes']['batteryPercentage']
  end

  def reachable?
    @data['isReachable']
  end

  def room
    @data['room']
  end

  def name=(new_name)
    response = @client.patch("/devices/#{id}", [{ attributes: { customName: new_name } }])
    raise "Failed to update name" unless response.code == 202

    @data['attributes']['customName'] = new_name
  end

  def reload
    @data = @client.get("/devices/#{id}")
  end
end
