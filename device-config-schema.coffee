module.exports = {
  title: "pimatic-owntracks device config schemas"
  Owntracks: {
    title: "Owntracks config options"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel"]
    properties:
      topic:
        description: "Topic of device state"
        type: "string"
      lat:
        description: "Latitude of your home location"
        type: "number"
        default: 0
      long:
        description: "Longitude of your home location"
        type: "number"
        default: 0
      radius:
        description: "The radius in meters from location to set presense"
        type: "number"
        default: 100
  }
}
