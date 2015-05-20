fs = require 'fs'
utils = require('./utils')

class Logger
  logFile: "log.log"
  loggerActive: true

  logText: (str) ->
    if @loggerActive
      fs.appendFile @logFile, str, (err) ->
        if err
          throw err

  formatCommand: (cmd) ->
    utils.formatObj cmd

  logIncomingCommand: (str) ->
    @logText "< #{str}\n"

  logOutgoingCommand: (cmd) ->
    str = @formatCommand cmd
    @logText "> #{str}"

exports.Logger = new Logger
