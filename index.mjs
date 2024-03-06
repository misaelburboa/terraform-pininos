export const handler = async (event) => {
  console.log("EVENT", event)
  // TODO implement
  const response = {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda!'),
  };
  return response;
};
