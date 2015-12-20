describe 'Users' do
  # Index
  describe 'GET /users' do
    context 'when Users exist in database' do
      let!(:user_1) { create :user }
      let!(:user_2) { create :user }

      it 'returns Users' do
        get '/users'

        expect(response.body).to be_json_eql(to_json(user_1, user_2))
        expect(response.status).to eq 200
      end
    end

    context 'when Users does not exist in database' do
      it 'returns empty data' do
        get '/users'

        expect(response.body).to eq empty_json_data
        expect(response.status).to eq 200
      end
    end
  end

  # Create
  describe 'USER /users' do
    context 'with valid params' do
      it 'creates a User' do
        post '/users', user: { email: 'email@email.com', password: 'qwerty' }

        user = User.first
        expect(user.email).to eq 'email@email.com'
        expect(user.password).to eq 'qwerty'

        expect(response.body).to be_json_eql(user.to_json)
        expect(response.status).to eq 201
      end
    end

    context 'with invalid params' do
      it 'does not create a User' do
        post '/users', user: { blah: 'bla' }

        expect(json).to be_jsonapi_validation_errors('email' => "can't be blank", 'password' => "can't be blank")
        expect(response.status).to eq 422
      end
    end
  end

  # Get
  describe 'GET /users/:id' do
    context 'when User exist in database' do
      let!(:user) { create :user }

      it 'returns User' do
        get "/users/#{user.id}"

        expect(response.body).to be_json_eql(user.to_json)
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

  # # Destroy
  describe 'DELETE /users/:id' do
    let!(:user) { create :user }

    context 'when User exists' do
      it 'deletes User' do
        delete "/users/#{user.id}"

        expect(User.count).to eq 0
        expect(response.body).to be_json_eql('')
        expect(response.status).to eq 200
      end
    end

    context 'when User does not exist' do
      it 'returns error' do
        delete '/users/123'

        expect(json).to be_jsonapi_not_found_error("Couldn't find User with 'id'=123")
        expect(response.status).to eq 404
      end
    end
  end

  # Update
  describe 'PATCH /users/:id' do
    context 'when User exists' do
      let(:user) { create :user }

      context 'with valid params' do
        it 'updates User' do
          patch "/users/#{user.id}", user: { email: 'new@email.com' }

          user.reload
          expect(user.email).to eq 'new@email.com'

          expect(response.body).to be_json_eql(user.to_json)
          expect(response.status).to eq 200
        end
      end

      describe 'Unprocessable Entity' do
        context 'with invalid params' do
          it 'does not update User' do
            patch "/users/#{user.id}", user: { email: '' }

            old_email = user.email
            user.reload
            expect(user.email).to eq old_email

            expect(json).to be_jsonapi_validation_errors('email' => "can't be blank")
            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
