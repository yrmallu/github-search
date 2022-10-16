# Github Repos Search

- It searches public github repositories

## Development & Testing

A Docker setup exists for development and testing purposes. For convenience, it is wrapped using
[DIP](https://github.com/bibendi/dip). Use `dip ls` to list all available wrappers.

### Initial setup

- Make sure Docker is installed and docker-compose is available.
- Run `dip provision`

### Running the services

`dip up`

### Running tests

- full test suite: `dip rspec`
- parts/individual files: `dip rspec something` / `dip rspec spec/something_spec.rb`

### Without Docker

Requirements:

- Ruby 3.1.2

You should then be able to use your regular flow (your preferred Ruby version manager, `bundle exec` etc.). For relevant commands, please check the entries in `dip.yml`.
