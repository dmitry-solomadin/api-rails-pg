describe 'Authentication' do
  describe 'POST /auth/sign_in' do
    context 'with valid params' do
      let!(:user) do
        create :user, email: 'email@email.com', password: '123', password_confirmation: '123',
                      first_name: 'Dmitry', last_name: 'Solomadin'
      end

      it 'authenticates a User' do
        post '/auth/sign_in', email: 'email@email.com', password: '123'

        expect(response.body).to be_json_eql({ data: User.first }.to_json)
        expect(response.status).to eq 200
      end
    end

    context 'with invalid params' do
      it 'does not authenticate a User' do
        post '/auth/sign_in', email: 'email@email.com', password: '123'

        expect(response.body).to be_json_eql({ errors: ['Invalid login credentials. Please try again.'] }.to_json)
        expect(response.status).to eq 401
      end
    end
  end
end

describe 'User management' do
  def invalid_auth_response(errors)
    { status: 'error', errors: errors }.to_json
  end

  describe 'POST /auth' do
    context 'with valid params' do
      it 'creates a User' do
        post '/auth', email: 'email@email.com', role: 'USER', password: 'qwerty', password_confirmation: 'qwerty'
        user = User.first
        expect(user.email).to eq 'email@email.com'
        expect(User.first.valid_password? 'qwerty').to be true

        expect(response.body).to be_json_eql({ data: user, status: 'success' }.to_json)
        expect(response.status).to eq 200
      end
    end

    context 'with invalid params' do
      it 'does not create a User' do
        post '/auth', user: { blah: 'bla' }

        auth_response = invalid_auth_response(['Please submit proper sign up data in request body.'])
        expect(response.body).to be_json_eql(auth_response)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'DELETE /auth' do
    context 'with valid params' do
      let!(:user) { create :user, email: 'email@email.com' }

      it 'does deletes a User' do
        delete_as_user '/auth'

        expect(User.count).to eq 0
        expect(response.body).to be_json_eql({ message: 'Account with uid email@email.com has been destroyed.',
                                               status: 'success' }.to_json)
        expect(response.status).to eq 200
      end
    end

    context 'with invalid params' do
      it 'does not delete a User' do
        delete '/auth', email: 'email@email.com'

        expect(response.body).to be_json_eql(invalid_auth_response(['Unable to locate account for destruction.']))
        expect(response.status).to eq 404
      end
    end
  end
end
