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

exports.okResponse = message => createResponse({ statusCode: 200, message: message });
exports.noContentResponse = () => { 204 };
exports.errorResponse = message => createResponse({ statusCode: 500, message: message })
