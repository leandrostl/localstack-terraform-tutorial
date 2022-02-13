const defaultHeaders = {
  'Content-Type': 'application/json',
};

const createResponse = ({ statusCode, headers = defaultHeaders, message }) => {
  const body = JSON.stringify({ message: message });
  return {
    statusCode,
    headers,
    body,
  };
};

exports.okResponse = (message) => { return createResponse({ statusCode: 200, message: message }) }
exports.errorResponse = (message) => { return createResponse({ statusCode: 500, message: message }) }
