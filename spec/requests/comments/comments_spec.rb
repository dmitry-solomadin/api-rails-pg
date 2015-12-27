describe 'Comments controller request' do
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

    context 'as authenticated user' do
      context 'with valid params' do
        it 'creates a Comment' do
          post_as_user '/comments', comment: { author_id: user.id, text: 'This is comment text',
                                               parent_id: post_1.id, parent_type: 'Post' }

          comment = Comment.first
          expect(comment.author_id).to eq user.id
          expect(comment.text).to eq 'This is comment text'
          expect(comment.parent).to eq post_1

          expect(response.body).to be_json_eql(comment.to_json)
          expect(response.status).to eq 200
        end
      end

      context 'with invalid params' do
        it 'does not create a Comment' do
          post_as_user '/comments', comment: { blah: 'bla' }

          expect(json).to be_jsonapi_validation_errors(
            'text' => "can't be blank",
            'parent' => "can't be blank",
            'author' => "can't be blank"
          )
          expect(response.status).to eq 422
        end
      end
    end

    context 'as unauthenticated user' do
      let(:response) { post '/comments' }
      it_behaves_like 'authenticate protected action'
    end
  end

  # Get
  describe 'GET /comments/:id' do
    context 'when Comment exist in database' do
      let!(:post) { create :post, author: user }
      let!(:comment) { create :comment, author: user, parent: post }
      let!(:child_comment) { create :comment, author: user, parent: comment }

      it 'returns Comment' do
        get "/comments/#{comment.id}"

        expect(response.body).to be_json_eql(comment.to_json)
        expect(response.status).to eq 200
      end

      it 'returns Comment with child comment' do
        get "/comments/#{comment.id}", include: :comments

        expect(response.body).to be_json_eql(comment.to_json(include: :comments))
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

    context 'as authenticated user' do
      context 'when Comment exists' do
        it 'deletes Comment' do
          delete_as_user "/comments/#{comment.id}"

          expect(Comment.count).to eq 0
          expect(response.body).to be_json_eql('')
          expect(response.status).to eq 200
        end
      end

      context 'when Comment does not exist' do
        it 'returns error' do
          delete_as_user '/comments/123'

          expect(json).to be_jsonapi_not_found_error("Couldn't find Comment with 'id'=123")
          expect(response.status).to eq 404
        end
      end

      context 'as unauthorized user' do
        let!(:user) { create :user }
        let!(:post_author) { create :user }
        let!(:post) { create :post, author: post_author }
        let(:comment) { create :comment, author: post_author, parent: post }

        it 'does not update a Post' do
          delete_as_user "/comments/#{comment.id}"

          expect(Comment.count).to eq 1
          expect(json).to be_jsonapi_forbidden_error
          expect(response.status).to eq 403
        end
      end
    end

    context 'as unauthenticated user' do
      let(:response) { delete '/comments/123' }
      it_behaves_like 'authenticate protected action'
    end
  end

  # Update
  describe 'PATCH /comments/:id' do
    context 'when Comment exists' do
      let(:user) { create :user }
      let(:post) { create :post, author: user }
      let(:comment) { create :comment, author: user, parent: post }

      context 'as authenticated user' do
        context 'with valid params' do
          it 'updates Comment' do
            patch_as_user "/comments/#{comment.id}", comment: { text: 'new text' }

            comment.reload
            expect(comment.text).to eq 'new text'

            expect(response.body).to be_json_eql(comment.to_json)
            expect(response.status).to eq 200
          end
        end

        context 'with invalid params' do
          it 'does not update Comment' do
            patch_as_user "/comments/#{comment.id}", comment: { text: '', parent_id: '' }

            comment.reload
            expect(comment.text).to eq 'text'

            expect(json).to be_jsonapi_validation_errors('text' => "can't be blank",
                                                         'parent' => "can't be blank",
                                                         'parent_id' => 'Change of parent_id not allowed!')
            expect(response.status).to eq 422
          end
        end

        context 'as unauthorized user' do
          let!(:user) { create :user }
          let!(:post_author) { create :user }
          let!(:post) { create :post, author: post_author }
          let(:comment) { create :comment, author: post_author, parent: post }

          it 'does not update a Comment' do
            patch_as_user "/comments/#{comment.id}", comment: { text: 'new text' }

            post.reload
            expect(comment.text).to eq 'text'

            expect(json).to be_jsonapi_forbidden_error
            expect(response.status).to eq 403
          end
        end
      end

      context 'as unauthenticated user' do
        let(:response) { patch '/comments/123' }
        it_behaves_like 'authenticate protected action'
      end
    end
  end
end
