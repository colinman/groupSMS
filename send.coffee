# requires
csv = require 'fast-csv'
prompt = require 'prompt'
Q = require 'q'
twilio = require 'twilio'
env = require 'node-env-file'

env __dirname + '/.env'

# constants (populated in .env)
SID = process.env.SID
token = process.env.token
originNumber = process.env.originNumber

client = new twilio.RestClient SID, token

# Check that args are right
if process.argv.length isnt 3 then return console.log 'Usage: node send.js [phone.csv]'

# read in CSV to memory
numbers = [] # array of phone numbers from csv
csv.fromPath(process.argv[2]).on "data", (data) ->
  numbers.push data
.on "end", -> prompt.start()

# Send an SMS text message to one number
sendText = (promises, text, number) ->
  number = "+#{number}"
  q = client.sendMessage
    to: number
    from: originNumber
    body: text    
  .catch (err) -> console.log "ERROR SENDING #{text} TO #{number}"
  .then (response) -> console.log "SENT #{response.body} TO #{response.to}"

  promises.push q

# Send SMS text message to entire group
sendGroupText = (text) ->
  promises = [] # completion promises      
  for number in numbers then sendText promises, text, number
  Q.all promises

# continous prompting
startPrompt = ->
  prompt.get ['text'], (err, result) ->
    if err then return console.log "ERROR in prompt"
    sendGroupText(result.text).then -> startPrompt()

console.log "Welcome to group text sender! Type in the text you'd like to send to the numbers listed in #{process.argv[2]} below. Please wait for the prompt before attempting to send another message. ^c to exit."
startPrompt()
