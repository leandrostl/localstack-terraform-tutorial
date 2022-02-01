const defaultHeaders = {
  'Content-Type': 'text/html; charset=utf-8',
};

const response = ({ statusCode, headers = defaultHeaders, body }) => {
  return {
    statusCode,
    headers,
    body,
  };
};

exports.handler = (event, context, callback) => {
  callback(
    null,
    response({
      statusCode: 200,
      body: `<h2>Seriously? Another Hello World, ${JSON.parse(event.body).name}?</h2>`
    }));
}