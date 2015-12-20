describe 'Comments' do
  let!(:user) { create :user }

  # Index
  describe 'GET /comments' do
    context 'when Comments exist in database' do
      let!(:post) { create :post, author: user }
      let!(:comment_1) { create :comment, author: user, parent: post }
      let!(:comment_2) { create :comment, author: user, parent: post }

      it 'returns Comments' do
        get '/comments'

        expect(response.body).to be_json_eql(to_json(comment_1, comment_2))
        expect(response.status).to eq 200
      end
    end

    context 'when Comments does not exist in database' do
      it 'returns empty data' do
        get '/comments'

        expect(response.body).to eq empty_json_data
        expect(response.status).to eq 200
      end
    end
  end

  # Create
  describe 'POST /comments' do
    let!(:post_1) { create :post, author: user }

    context 'with valid params' do
      it 'creates a Comment' do
        post '/comments', comment: { author_id: user.id, text: 'This is comment text',
                                     parent_id: post_1.id, parent_type: 'Post' }

        comment = Comment.first
        expect(comment.author_id).to eq user.id
        expect(comment.text).to eq 'This is comment text'
        expect(comment.parent).to eq post_1

        expect(response.body).to be_json_eql(comment.to_json)
        expect(response.status).to eq 201
      end
    end

    context 'with invalid params' do
      it 'does not create a Comment' do
        post '/comments', comment: { blah: 'bla' }

        expect(json).to be_jsonapi_validation_errors(
          'text' => "can't be blank",
          'parent' => "can't be blank",
          'author' => "can't be blank"
        )
        expect(response.status).to eq 422
      end
    end
  end

  # Get
  describe 'GET /comments/:id' do
    context 'when Comment exist in database' do
      let!(:post) { create :post, author: user }
      let!(:comment) { create :comment, author: user, parent: post }

      it 'returns Comment' do
        get "/comments/#{comment.id}"

        expect(response.body).to be_json_eql(comment.to_json)
        expect(response.status).to eq 200
      end
    end

    context 'when Comment does not exist in database' do
      it 'returns empty data' do
        get '/comments/123'

        expect(json).to be_jsonapi_not_found_error("Couldn't find Comment with 'id'=123")
        expect(response.status).to eq 404
      end
    end
  end

  # Destroy
  describe 'DELETE /comments/:id' do
    let!(:user) { create :user }
    let!(:post) { create :post, author: user }
    let!(:comment) { create :comment, author: user, parent: post }

    context 'when Comment exists' do
      it 'deletes Comment' do
        delete "/comments/#{comment.id}"

        expect(Comment.count).to eq 0
        expect(response.body).to be_json_eql('')
        expect(response.status).to eq 200
      end
    end

    context 'when Comment does not exist' do
      it 'returns error' do
        delete '/comments/123'

        expect(json).to be_jsonapi_not_found_error("Couldn't find Comment with 'id'=123")
        expect(response.status).to eq 404
      end
    end
  end

  # Update
  describe 'PATCH /comments/:id' do
    context 'when Comment exists' do
      let(:user) { create :user }
      let(:post) { create :post, author: user }
      let(:comment) { create :comment, author: user, parent: post }

      context 'with valid params' do
        it 'updates Comment' do
          patch "/comments/#{comment.id}", comment: { text: 'new text' }

          comment.reload
          expect(comment.text).to eq 'new text'

          expect(response.body).to be_json_eql(comment.to_json)
          expect(response.status).to eq 200
        end
      end

      describe 'Unprocessable Entity' do
        context 'with invalid params' do
          it 'does not update Comment' do
            patch "/comments/#{comment.id}", comment: { text: '', parent_id: '' }

            comment.reload
            expect(comment.text).to eq 'text'

            expect(json).to be_jsonapi_validation_errors('text' => "can't be blank",
                                                         'parent' => "can't be blank",
                                                         'parent_id' => 'Change of parent_id not allowed!')
            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
