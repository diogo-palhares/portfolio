// CloudFront Function (viewer-request, runtime cloudfront-js-2.0)
function handler(event) {
  var request = event.request;
  var host = request.headers.host ? request.headers.host.value : '';

  // www.dominio.com -> dominio.com (URL canônica única)
  if (host.startsWith('www.')) {
    return {
      statusCode: 301,
      statusDescription: 'Moved Permanently',
      headers: {
        location: { value: 'https://' + host.substring(4) + request.uri },
      },
    };
  }

  // Astro gera /pagina/index.html; o S3 via OAC não resolve índices sozinho
  var uri = request.uri;
  if (uri.endsWith('/')) {
    request.uri = uri + 'index.html';
  } else if (!uri.split('/').pop().includes('.')) {
    request.uri = uri + '/index.html';
  }

  return request;
}
