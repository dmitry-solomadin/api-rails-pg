describe 'Posts controller request' do
  let!(:user) { create :user }

  # Index
  describe 'GET /posts' do
    context 'when Posts exist in database' do
      let!(:post_1) { create :post, author: user }
      let!(:post_2) { create :post, author: user }

      it 'returns Posts' do
        get '/posts'

        expect(response.body).to be_json_eql(json_helper(post_1, post_2))
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
    context 'as authenticated user' do
      context 'with valid params' do
        it 'creates a Post' do
          post_as_user '/posts', post: { author_id: user.id, body: 'This is post body', header: 'Great header' }

          post = Post.first
          expect(post.author_id).to eq user.id
          expect(post.body).to eq 'This is post body'
          expect(post.header).to eq 'Great header'

          expect(response.body).to be_json_eql(json_helper(post))
          expect(response.status).to eq 200
        end
      end

      context 'with invalid params' do
        it 'does not create a Post' do
          post_as_user '/posts', post: { blah: 'bla' }

          expect(json).to be_jsonapi_validation_errors(
            'body' => "can't be blank",
            'header' => "can't be blank",
            'author' => "can't be blank"
          )
          expect(response.status).to eq 422
        end
      end
    end

    context 'as unauthenticated user' do
      let(:response) { post '/posts' }
      it_behaves_like 'authenticate protected action'
    end
  end

  # Get
  describe 'GET /posts/:id' do
    context 'when Post exist in database' do
      let!(:post) { create :post, author: user }
      let!(:comment_1) { create :comment, author: user, parent: post }
      let!(:comment_2) { create :comment, author: user, parent: post }

      it 'returns Post' do
        get "/posts/#{post.id}"

        expect(response.body).to be_json_eql(json_helper(post))
        expect(response.status).to eq 200
      end

      it 'returns Post with comments' do
        get "/posts/#{post.id}", include: 'comments'

        expect(response.body).to be_json_eql(json_helper(post, include: [:comments]))
        expect(response.status).to eq 200
      end
    end

    context 'when Post does not exist in database' do
      it 'returns empty data' do
        get '/posts/123'

        expect(json).to be_jsonapi_not_found_error("Couldn't find Post with 'id'=123")
        expect(response.status).to eq 404
      end
    end
  end

  # Destroy
  describe 'DELETE /posts/:id' do
    let!(:user) { create :user }
    let!(:post) { create :post, author: user }

    context 'as authenticated user' do
      context 'when Post exists' do
        it 'deletes Post' do
          delete_as_user "/posts/#{post.id}"

          expect(Post.count).to eq 0
          expect(response.body).to be_json_eql('')
          expect(response.status).to eq 200
        end
      end

      context 'when Post does not exist' do
        it 'returns error' do
          delete_as_user '/posts/123'

          expect(json).to be_jsonapi_not_found_error("Couldn't find Post with 'id'=123")
          expect(response.status).to eq 404
        end
      end

      context 'as unauthorized user' do
        let!(:user) { create :user }
        let!(:post_author) { create :user }
        let!(:post) { create :post, author: post_author }

        it 'does not delete a Post' do
          delete_as_user "/posts/#{post.id}"

          expect(Post.count).to eq 1
          expect(json).to be_jsonapi_forbidden_error
          expect(response.status).to eq 403
        end
      end
    end

    context 'as unauthenticated user' do
      let(:response) { delete '/posts/123' }
      it_behaves_like 'authenticate protected action'
    end
  end

  # Update
  describe 'PATCH /posts/:id' do
    context 'when Post exists' do
      let(:user) { create :user }
      let(:post) { create :post, author: user }

      context 'as authenticated user' do
        context 'with valid params' do
          it 'updates Post' do
            patch_as_user "/posts/#{post.id}", post: { body: 'new body', header: 'new header' }

            post.reload
            expect(post.body).to eq 'new body'
            expect(post.header).to eq 'new header'

            expect(response.body).to be_json_eql(json_helper(post))
            expect(response.status).to eq 200
          end
        end

        context 'with invalid params' do
          it 'does not update Post' do
            patch_as_user "/posts/#{post.id}", post: { body: '', header: '' }

            post.reload
            expect(post.body).to eq 'body'

            expect(json).to be_jsonapi_validation_errors('body' => "can't be blank", 'header' => "can't be blank")
            expect(response.status).to eq 422
          end
        end

        context 'as unauthorized user' do
          let!(:user) { create :user }
          let!(:post_author) { create :user }
          let!(:post) { create :post, author: post_author }

          it 'does not update a Post' do
            patch_as_user "/posts/#{post.id}", post: { body: 'new body', header: 'new header' }

            post.reload
            expect(post.body).to eq 'body'
            expect(post.header).to eq 'header'

            expect(json).to be_jsonapi_forbidden_error
            expect(response.status).to eq 403
          end
        end
      end

      context 'as unauthenticated user' do
        let(:response) { patch '/posts/123' }
        it_behaves_like 'authenticate protected action'
      end
    end
  end
end
