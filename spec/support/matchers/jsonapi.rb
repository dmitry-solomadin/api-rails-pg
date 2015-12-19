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
