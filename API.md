API
===

`GET /apps`
-----------
Returns all applications

**Response:**
``` json
[
    <array of applications>
]
```

`POST /apps`
------------
Creates an application.

**Request:**
``` json
{
    "name": "<application name>"
}
```


`POST /apps/<app_name>/devices`
-------------------------------
Associates a device with the application.

**Request:**
``` json
{
    "name": "<device name>"
}
```


`POST /apps/<app_name>/deployments`
-----------------------------------
Deploys a new version.

**Request:**
For performance use `multipart/form-data` instead of JSON.
`<board name>` is defined as `SUPPORTED_BOARDS` in `constants.rb`.

```
images[][board] = "<board name>"
images[][file]  = <image file>
```

`GET /devices/<device_name>/image`
----------------------------------
Downloads the latest deployed image for the the device.

**Notes:**
This endpoint is for BaseOS.

**Request:**
Empty.

**Response:**

The deployed image file.


`PUT /devices/<deivce_name>/status`
-----------------------------------
Updates the status of the device.

**Notes:**
This endpoint is for BaseOS.

**Request:**
`<device status>` is defined as `DEVICE_STATUSES` in `constants.rb`.

``` json
{
    "board":  "<board name>",
    "status": "<device status>"
}
```
