module.exports = {
  title: "OwnTracks plugin config options"
  type: "object"
  properties:
    host:
      description: "The IP or hostname of the MQTT broker"
      type: "string"
      default: "127.0.0.1"
    port:
      description: "The port of the MQTT broker"
      type: "integer"
      default: 1883
    username:
      description: "The login name"
      type: "string"
      default: ""
    password:
      description: "The password"
      type: "string"
      default: ""
}