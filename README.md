# Welcome to Belly Connection Service

This Rack app is a small service to be used in conjunction with Belly's Check-In code challenge. The primary function is to create, retrieve, and delete connections from a database.

## Requirements
* Connection Service runs on Ruby 2.0.0-p247. Please install with your favorite version manager.
* Connection Service routinely makes calls to User Service and Merchant Service to validate existence: Clone those services at [here](https://github.com/leeacto/user-service) and [here](https://github.com/leeacto/merchant-service)

## Installation
* Clone Connection Service from [here](https://github.com/leeacto/connection-service)
* Run <code>bundle install</code>
* Run <code>rake db:reset; RACK_ENV=test rake db:reset</code> to create the database
* Run <code>rake db:migrate; RACK_ENV=test rake db:migrate</code> to create tables

## Usage
Connection Service provides API endpoints to create, retrieve, and delete connections (resource name: connections)
The service can be run on port 9395 with <code>shotgun -p 9395</code>
Use <code>rake routes</code> to view the available endpoints

