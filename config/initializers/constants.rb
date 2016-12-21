API_VERSION = '1'
SUPPORTED_BOARDS = %w(esp8266)
BUILD_STATUSES = %w(queued building success failure)
DEVICE_STATUSES = %w(new ready running down relaunch)
DEVICE_SECRET_PREFIX_LEN = 20
LOGGING_MAX_LINES = 128
RESERVED_USER_NAMES = %w(
  home
  apps
  devices
  settings
  builds
  deployments
  create
  me
  account
  admin
  api
  blog
  cache
  changelog
  enterprise
  help
  jobs
  lists
  login
  logout
  news
  plans
  popular
  projects
  security
  search
  register
  invite
  shop
  jobs
  translations
  signup
  status
  tour
  wiki
  better
  hosting
  auth
  documentation
  support
  easter-egg
  admin
)
