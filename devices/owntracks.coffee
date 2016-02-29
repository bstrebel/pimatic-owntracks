module.exports = (env) ->

  Promise = env.require 'bluebird'
  geolib = require 'geolib'

  class MqttOwntracks extends env.devices.PresenceSensor

    constructor: (@config, @plugin, lastState) ->
      @id = config.id
      @name = config.name
      @_presence = lastState?.presence?.value or false
      @pimaticLat = config.lat
      @pimaticLong = config.long
      @radius = config.radius

      if @plugin.connected
        @onConnect()

      @plugin.mqttclient.on('connect', =>
        @onConnect()
      )

      @plugin.mqttclient.on('message', (topic, message) =>
        if @config.topic == topic
          try data = JSON.parse(message)
              if data?
                if data then for key, value of data
                  if key == 'lat'
                    lat = value
                  if key == 'lon'
                    long = value
                if lat? and long?
                  start_loc = {
                    lat: lat
                    lng: long
                  }
                  end_loc = {
                    lat: @pimaticLat
                    lng: @pimaticLong
                  }
                  linearDistance = geolib.getDistance(start_loc, end_loc)
                  if linearDistance < radius
                    @_setPresence(yes)
                  else
                    @_setPresence(no)

              #env.logger.debug "#{@name} with id:#{@id}: Message is not harmony with onMessage or offMessage in config.json or with default values"
        )
      super()

    onConnect: () ->
      @plugin.mqttclient.subscribe(@config.topic)

    getPresence: () -> Promise.resolve(@_presence)