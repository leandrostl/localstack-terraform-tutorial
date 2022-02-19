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

exports.createdResponse = (message) => { return createResponse({ statusCode: 201, message: message }) }
exports.errorResponse = (message) => { return createResponse({ statusCode: 500, message: message }) }
