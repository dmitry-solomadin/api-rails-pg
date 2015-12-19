describe 'Posts' do
  describe 'POST /posts', :vcr do
    let(:user) { create :user }

    context 'with valid params' do
      it 'creates a Post' do
        post '/posts', post: { author_id: user.id, body: 'This is post body', header: 'Great header' }

        post = Post.first
        expect(post.author_id).to eq user.id
        expect(post.body).to eq 'This is post body'
        expect(post.header).to eq 'Great header'

        expect(response.body).to be_json_eql(post.to_json)
        expect(response.status).to eq 201
      end
    end

    context 'with invalid params' do
      it 'does not create a Post' do
        post '/posts', post: { blah: 'bla' }

        expect(json).to be_jsonapi_validation_errors(
          'body' => "can't be blank",
          'header' => "can't be blank",
          'author' => "can't be blank"
        )
        expect(response.status).to eq 422
      end
    end
  end
end
