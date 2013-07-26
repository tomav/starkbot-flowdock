# StarkBot-Flowdock

StarkBot is a bot that connects to Flowdock Stream API, and interacts with connected users.
It includes a system of plugins (handlers) to extend its capabilities.

This bot is based on [https://github.com/shatsar/flowbot](https://github.com/shatsar/flowbot) and uses the same handler behaviour.

However, some things have been improved:
* boot via rake task
* autoreconnect to flowdock stream api
* added basic interaction with flowdock api (push message to flow / team inbox, get a user nickname)
* added some basic handlers

## Requirements

* Flowdock API tokens (personnal and flows)
* Ruby 1.9.3+

## Features

* Plugin handler 
* Code documentation (rdoc)

## Plugins

* `BaseHandler` with basic flowdock interaction (say, team, get_username)
* `ConsoleHandler` which prints basic flowdock activity to console (usefull for debug)
* `HelloHandler` which replys to "hello"
* `ReplyHandler` which replys to user messages
* `RconHandler` which allow to send RCON commands to HLDS servers

## Usage

* Remove `-sample` from config files
* Edit config files like `config.rb` and others located in `handlers/`
* Start the bot with `starkbot:run`
