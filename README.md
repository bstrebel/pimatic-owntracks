
# pimatic-owntracks

Pimatic Plugin forOwntracks

## Status of implementation

This version supports the following

* PresenceSensor

## Getting Started

This section is still work in progress.

## Plugin Configuration

While run MQTT broker on localhost and on a standard port, without autentification, you can load the plugin by editing your `config.json` to include the following
in the `plugins` section.

    {
        "plugin": "owntracks"
    }

Full config

    {
      "plugin": "owntracks",
      "host": "127.0.0.1",
      "port": 1883,
      "username": "",
      "password": ""
    }

The configuration for a broker is an object comprising the following properties.

| Property  | Default     | Type    | Description                                                                           |
|:----------|:------------|:--------|:--------------------------------------------------------------------------------------|
| host      | "127.0.0.1" | String  | Broker hostname or IP                                                                 |
| port      | 1883        | integer | Broker port                                                                           |
| username  | -           | String  | The login name                                                                        |
| password  | -           | String  | The Password                                                                          |


## Device Configuration

Devices must be added manually to the device section of your pimatic config.

### Owntracks Sensor

`Owntracks` is a OwnTracks device based on the `PresenceSensor` device class.

    {
      "name": "My Phone",
      "id": "my-iphone",
      "class": "Owntracks",
      "topic": "owntracks/my-phone/iphone",
      "lat": 33.19469267,
      "long": 35.65596431,
	  "radius": 100
    }

It has the following configuration properties:

| Property   | Default  | Type    | Description                                 |
|:-----------|:---------|:--------|:--------------------------------------------|
| topic      | -        | String  | Topic for device state                      |
| lat		 | 0        | Number  | lat number                                  |
| long 		 | 0        | Number  | long number                                 |

The presence sensor exhibits the following attributes:

| Property      | Unit  | Type    | Acronym | Description                            |
|:--------------|:------|:--------|:--------|:---------------------------------------|
| presence      | -     | Boolean | -       | Presence State, true is present, false is absent |

The following predicates are supported:

* {device} is present|absent

##Rules


##Configure OwnTracks


## Credits

<a href="https://github.com/sweetpi">sweet pi</a> for his work on best automatization software <a href="http://pimatic.org/">Pimatic</a> and all men from the pimatic community.

<a href="https://github.com/andremiller">Andre Miller</a> for for his module <a href="https://github.com/andremiller/pimatic-mqtt-simple/">pimatic-mqtt-simple</a> from which it comes also part of the code.

<a href="https://github.com/mwittig">Marcus Wittig</a> for his nice module <a href="https://github.com/mwittig/pimatic-johnny-five">pimatic-johnny-five</a> which was a big inspiration.