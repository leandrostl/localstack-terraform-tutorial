const { createdResponse, errorResponse } = require("./src/response");
const queue = require('./src/queue')

exports.handler = (event, context, callback) => {
  queue.send(event.body)
    .then(data => {
      const quote = createdResponse(`Quote recorded in proccessing queue with id: ${data.MessageId}.`);
      callback(null, quote);
    })
    .catch(error => {
      const quote = errorResponse(`Could not send the quote to queue. Error: ${error}`);
      callback(null, quote);
    })
}