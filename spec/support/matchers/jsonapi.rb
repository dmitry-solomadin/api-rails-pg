RSpec::Matchers.define :be_jsonapi_validation_errors do |errors|
  match do |response|
    response['errors'] &&
      response['errors'].size == errors.size &&
      errors.all? do |attribute, messages|
        response['errors'].include?(
          'status' => 422,
          'title' => 'Unprocessable entity',
          'source' => { 'attribute' => "#{attribute}" },
          'message' => Array(messages).join(', ')
        )
      end
  end
end

RSpec::Matchers.define :be_jsonapi_not_found_error do |message|
  match do |response|
    response == {
      'errors' => [
        {
          'status' => 404,
          'title' => 'Not found',
          'source' => { 'attribute' => '' },
          'message' => message
        }
      ]
    }
  end
end

RSpec::Matchers.define :be_jsonapi_forbidden_error do
  match do |response|
    response == {
      'errors' => [
        {
          'status' => 403,
          'title' => 'Forbidden',
          'source' => { 'attribute' => '' },
          'message' => 'You are not authorized to access this page.'
        }
      ]
    }
  end
end
