class Dirigera::Blinds < Dirigera::Device
  def up
    self.target_level = 0
  end

  def down
    self.target_level = 100
  end

  def state
    @data['attributes']['blindsState']
  end

  def current_level
    @data['attributes']['blindsCurrentLevel']
  end

  def target_level
    @data['attributes']['blindsTargetLevel']
  end

  def target_level=(level)
    raise ArgumentError, 'level must be between 0 and 100' unless (0..100).include?(level)

    response = @client.patch("/devices/#{id}", [{ attributes: { blindsTargetLevel: level } }])
    raise 'Failed to update target level' unless response.code == 202

    @data['attributes']['blindsTargetLevel'] = level
  end
end
