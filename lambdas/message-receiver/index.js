const queue = require('./src/queue')

const defaultHeaders = {
  'Content-Type': 'application/json',
};

const createResponse = ({ statusCode, headers = defaultHeaders, body }) => {
  return {
    statusCode,
    headers,
    body,
  };
};

exports.handler = async (event, context, callback) => {
  let message;
  try {
    message = createResponse({
      statusCode: 200,
      body: JSON.stringify(
        {
          message: `Message sent to proccessing queue. Message id: ${await queue.send(event.body)}.`
        }
      )
    });
  } catch (error) {
    message = createResponse({
      statusCode: 500,
      body: JSON.stringify(
        {
          message: `Could not send message to queue. Error: ${error}`
        }
      )
    });
  }


  callback(null, message);
}