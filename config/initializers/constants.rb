API_VERSION = '1'
SUPPORTED_BOARDS = %w(esp8266)

BUILD_STATUSES = %w(queued building success failure)

# TODO: down: The device is down.
# new: The device is created.
# ready: The device has booted and is ready for running an app.
# running: The device is running an app.
DEVICE_STATUSES = %w(new ready running)
