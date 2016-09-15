# Pimatic OwnTracks plugin
module.exports = (env) ->

  Promise = env.require 'bluebird'
  geolib = require 'geolib'
  mqtt = require 'mqtt'

  # Pimatic Owntracks Plugin class
  class OwntracksPlugin extends env.plugins.Plugin

    init: (app, @framework, config) =>
  
      @connected = false

      options = (
        host: config.host
        port: config.port
        username: config.username or false
        password: if config.password then new Buffer(config.password) else false
        keepalive: 20
        clientId: 'pimatic_' + Math.random().toString(16).substr(2, 8)
        reconnectPeriod: 5000
        connectTimeout: 30000
        protocolVersion: config.protocolVer
        protocolId: config.protocolId
      )

      Connection = new Promise( (resolve, reject) =>
        @mqttclient = new mqtt.connect(options)
        @mqttclient.on("connect", () =>
          @connected = true
          env.logger.info "Owntracks successfuly connected to MQTT Broker"
          resolve()
        )
        @mqttclient.on('error', reject)
        return
      ).timeout(50000).catch( (error) ->
        env.logger.error "Owntracks error on connecting to MQTT Broker #{error.message}"
        env.logger.debug error.stack
        return
      )

      @mqttclient.on 'reconnect', () =>
        env.logger.info "Owntracks reconnecting to MQTT Broker"

      @mqttclient.on 'offline', () ->
        @connected = false
        env.logger.info "Owntracks MQTT Broker is offline"

      @mqttclient.on 'error', (error) ->
        @connected = false
        env.logger.error "Owntracks connection error: #{error}"
        env.logger.debug error.stack

      @mqttclient.on 'close', () ->
        @connected = false
        env.logger.info "Owntracks connected with the MQTT Broker was closed"  

      # register device

      deviceConfigDef = require("./device-config-schema")
      # @framework.ruleManager.addActionProvider(new MqttActionProvider(@framework, @mqttclient))

      @framework.deviceManager.registerDeviceClass("OwntracksDevice", {
        configDef: deviceConfigDef.OwntracksDevice
        createCallback: (config,lastState) =>
          device  =  new OwntracksDevice(config,lastState,@)
          return device
        })

  class OwntracksDevice extends env.devices.PresenceSensor

    constructor: (@config, lastState, @plugin) ->
      @id = @config.id
      @name = @config.name
      @_presence = lastState?.presence?.value or false
      @pimaticLat = @config.lat
      @pimaticLong = @config.long
      @radius = @config.radius

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
              if linearDistance < @radius
                @_setPresence(yes)
              else
                @_setPresence(no)

              #env.logger.debug "#{@name} with id:#{@id}: Message is not harmony with onMessage or offMessage in config.json or with default values"
      )
      super()
    
    destroy: () ->
      @plugin.mqttclient.unsubscribe(@config.topic)
      super()

    onConnect: () ->
      @plugin.mqttclient.subscribe(@config.topic)

    getPresence: () -> 
      Promise.resolve(@_presence)


  # Create a instance of my plugin
  # and return it to the framework.
  return new OwntracksPlugin