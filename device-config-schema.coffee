module.exports = {
  title: "pimatic-owntracks device config schemas"
  OwntracksDevice: {
    title: "Owntracks config options"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel"]
    properties:
      topic:
        description: "Topic of device state"
        type: "string"
      lat:
        description: "Latitude of location to monitor"
        type: "number"
        default: 0
      long:
        description: "Longitude of location to monitor"
        type: "number"
        default: 0
      radius:
        description: "The radius in meters from location to set presense"
        type: "number"
        default: 100
  }
}