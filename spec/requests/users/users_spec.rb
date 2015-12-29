describe 'Users controller request' do
  # Get
  describe 'GET /users/:id' do
    context 'when User exist in database' do
      let!(:user) { create :user }

      it 'returns User' do
        get "/users/#{user.id}"

        expect(response.body).to be_json_eql(json_helper(user))
        expect(response.status).to eq 200
      end
    end

    context 'when User does not exist in database' do
      it 'returns empty data' do
        get '/users/123'

        expect(json).to be_jsonapi_not_found_error("Couldn't find User with 'id'=123")
        expect(response.status).to eq 404
      end
    end
  end
end
