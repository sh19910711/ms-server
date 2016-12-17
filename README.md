Welcome to MakeStack
====================

[![Build Status](https://travis-ci.org/makestack/server.svg?branch=master)](https://travis-ci.org/makestack/server)
[![Code Climate](https://codeclimate.com/github/makestack/server/badges/gpa.svg)](https://codeclimate.com/github/makestack/server)
[![Test Coverage](https://codeclimate.com/github/makestack/server/badges/coverage.svg)](https://codeclimate.com/github/makestack/server/coverage)


## Requirements

- RDBMS: PostgreSQL (recommended) or MySQL
- Redis
- Docker


## Development

```sh
$ bundle install
$ rails db:create db:schema:load
$ bundle exec foreman start
```

## License

MIT
