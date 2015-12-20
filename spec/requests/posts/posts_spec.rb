describe 'Posts' do
  let!(:user) { create :user }

  # Index
  describe 'GET /posts' do
    context 'when Posts exist in database' do
      let!(:post_1) { create :post, author: user }
      let!(:post_2) { create :post, author: user }

      it 'returns Posts' do
        get '/posts'

        expect(response.body).to be_json_eql(to_json(post_1, post_2))
        expect(response.status).to eq 200
      end
    end

    context 'when Posts does not exist in database' do
      it 'returns empty data' do
        get '/posts'

        expect(response.body).to eq empty_json_data
        expect(response.status).to eq 200
      end
    end
  end

  # Create
  describe 'POST /posts' do
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

  # Get
  describe 'GET /posts/:id' do
    context 'when Post exist in database' do
      let!(:post) { create :post, author: user }

      it 'returns Post' do
        get "/posts/#{post.id}"

        expect(response.body).to be_json_eql(post.to_json)
        expect(response.status).to eq 200
      end
    end

    context 'when Post does not exist in database' do
      it 'returns empty data' do
        get '/posts/123'

        expect(response.body).to eq 'null'
        expect(response.status).to eq 200
      end
    end
  end


end
