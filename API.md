API
===

Glossary
--------

- `<team>`: An user or team name.
- **board type:** `esp8266`
- **device tag:** A string can be set on each device used to deploy an app to
  only a part of devices.
- **device secret:** The secret token written to devices. The server authenticates
  a device by the token.
- **group id:** The random (usually UUID) string for grouping deployments.
- **device statuses:**
  - `new`: The device is created.
  - `ready`: The device has booted and is ready for running an app.
  - `running`: The device is running an app.


`POST /auth`
------------
Create an user.

**Request:**

``` json
{
    "name": "<username>",
    "email": "<email address>",
    "password": "<password>",
    "password_confirmation": "<password>",
}
```

**Response:**
``` json
{}
```


**Status codes:**
- `200`: Success.


`DELETE /auth`
--------------
Delete the current user.

**Request:**
Empty.

**Response:**
``` json
{}
```

**Status codes:**
- `200`: Success.


`GET /<team>/devices`
-----------------------
Returns all devices.

**Request:**
Empty.

**Response:**
``` json
{
    "devices": [
      name: "<device name>",
      board: "<board type>",
      status: "<refer constants.rb>",
      tag: "<device tag>",
    ]
}
```

**Status codes:**
- `200`: Success.


`POST /<team>/devices`
-----------------------
Registers a device.

**Request:**
``` json
{
    "device_name":  "<device name>: /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/",
    "board": "<board type>",
    "tag":   "<device tag>: string or null"
}
```

**Response:**
``` json
{
    "device_secret": "<device secret>"
    "error": "<error message on falure>"
    "reasons": ["a list of reasons on validaton error"]
}
```

**Status codes:**
- `200`: Success.
- `422`: Validation error.


`DELETE /<team>/devices/<device_name>`
--------------------------------------
Delete a device.

**Request:**
Empty.

**Response:**
```
{}
```

**Status codes:**
- `200`: Success.


`POST /<team>/devices/<device_name>`
------------------------------------
Update device information.

**Request:**
``` json
{
    "board": "<board type>",
    "tag":   "<device tag>: string or null"
}
```

**Response:**
``` json
{}
```

**Status codes:**
- `200`: Success.
- `422`: Validation error.


`PUT /<team>/devices/<device_name>/relauch`
-------------------------------------------
Restart the app on the device.

**Request:**
Empty.

**Response:**
``` json
{}
```

**Status codes:**
- `200`: Success.


`GET /<team>/apps`
-----------------
Returns all applications.

**Request:**
No parameters.

**Response:**
``` json
{
    "applications": [
        {
            "name": "<application name>"
        }
    ]
}
```


`POST /<team>/apps`
-------------------
Creates an application.

**Request:**
``` json
{
    "app_name": "<application name>: /\A[a-zA-Z][a-zA-Z0-9\-\_]*\z/"
}
```

**Response:**

``` json
{
    "error": "<error message on failure>"
    "reasons": ["a list of reasons on validaton error"]
}
```

**Status codes:**
- `200`: Success.
- `404`: Validation error.


`DELETE /<team>/apps/<app_name>`
--------------------------------
Delete an app.

**Request:**
Empty.

**Response:**
```
{}
```

**Status codes:**
- `200`: Success.


`POST /<team>/apps/<app_name>/devices`
--------------------------------------
Associates a device with the application.

**Request:**
``` json
{
    "deivce_name": "<device name>"
}
```

**Response:**
``` json
{
    "error": "<error message on falure>"
}
```

**Status codes:**
- `200`: Success.
- `404`: Device or app not found.


`POST /apps/<app_name>/builds`
------------------------------
Builds and deploys an app.

**Notes:**
Build and deployment is performed asynchronously. All deployments
ocurred in the same build have same group id.

**Request:**
For performance use `multipart/form-data` instead of JSON.

```
source_file = <source .zip file>
tag         = "<target tag>: null or string"
```

**Response:**
``` json
{
    "error": "<error message on falure>"
    "reasons": ["a list of reasons on validaton error"]
}
```

**Status codes:**
- `202`: The deployment is successfully queued.
- `422`: Validation error.


`POST /apps/<app_name>/deployments`
-----------------------------------
Deploys a pre-built image.

**Request:**
For performance use `multipart/form-data` instead of JSON.

```
board    = "<target board type>"
image    = <image file>
tag      = "<target tag>: null or string"
group_id = "<group id>"
```

**Response:**
``` json
{
    "error": "<error message on falure>"
    "reasons": ["a list of reasons on validaton error"]
}
```

**Status codes:**
- `200`: Success.
- `422`: Validation error.


`GET /devices/<device_secret>/image`
------------------------------------
Downloads the latest deployed image for the the device. If `deployment_id` is speicified,
it returns the corresponding image. If not, it returns the latest image for the device.

This endpoints *partially* supports [Range header](https://tools.ietf.org/html/rfc7233). The
acceptable forms are: `Range: bytes=<start>-<end>` and `Range: bytes=<start>-`.

**Notes:**
This endpoint is for BaseOS.

**Request:**
Parameters are speicified in query string or JSON.

```
deployment_id = "<deployment id>"
```

**Response:**
Image file data.

**Status codes:**
- `200`: Success.
- `403`: The specified deployment exists but the device is not associated to the app.
- `404`: The specified deployment is not found, the specified deployment is not for the device,
         or no deployments created for the device.


`PUT /devices/<deivce_secret>/heartbeat`
---------------------------------------
Updates the status of the device.

**Notes:**
This endpoint is for BaseOS to send heartbeat.

**Request:**
Parameters are speicified in query string. The request body contains
the log messages.

```
status = "<device status>"
```

**Response:**
- `<integer>`: The latest deployment ID for the device
- `X`: No deployments.
- `R`: Relaunch the app.

**Status codes:**
- `200`: Success
- `404`: The device not found.
