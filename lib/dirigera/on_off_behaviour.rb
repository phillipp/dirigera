module Dirigera::OnOffBehaviour
  def on?
    @data['attributes']['isOn']
  end

  def off?
    !on?
  end

  def on
    response = @client.patch("/devices/#{id}", [{ attributes: { isOn: true } }])
    raise "Failed to update attribute isOn" unless response.code == 202

    @data['attributes']['isOn'] = true
  end

  def off
    response = @client.patch("/devices/#{id}", [{ attributes: { isOn: false } }])
    raise "Failed to update attribute isOn" unless response.code == 202

    @data['attributes']['isOn'] = false
  end
end
