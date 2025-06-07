require 'swagger_helper'

RSpec.describe 'API V1 Posts', type: :request do
  # Create a user before running tests, so posts can reference a valid user_id
  before do
    @user = User.create!(email: 'test@example.com', password: 'password')
    Post.create!(user_id: @user.id, title: 'Sample Post', status: 0, content: 'This is a sample post.')
    Post.create!(user_id: @user.id, title: 'Another Post', status: 1, content: 'This is another post.')
  end

  path '/api/v1/posts' do
    get 'Retrieves all posts' do
      tags 'Posts'                    # Swagger: Group endpoints under "Posts" tag
      produces 'application/json'    # Swagger: Response content type

      response '200', 'posts found' do
        # RSpec: Run the test and expect HTTP 200 response
        run_test!
      end
    end

    post 'Creates a post' do
      tags 'Posts'
      consumes 'application/json'    # Swagger: Request content type
      produces 'application/json'    # Swagger: Response content type

      # Swagger: Define the request body schema for creating a post
      parameter name: :post_params, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          title: { type: :string },
          status: { type: :integer, default: 0 },
          content: { type: :string }
        },
        required: %w[user_id title content]
      }

      response '201', 'post created' do
        # RSpec: Provide valid request payload
        let(:post_params) { { user_id: @user.id, title: 'New Post', status: 0, content: 'Post content' } }
        # RSpec: Run the test and expect HTTP 201 response
        run_test!
      end

      response '422', 'invalid request' do
        # RSpec: Provide invalid request payload to test validation errors
        let(:post_params) { { user_id: nil, title: '', content: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/posts/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'ID of the post' # Swagger: Path parameter

    get 'Retrieves a post' do
      tags 'Posts'
      produces 'application/json'

      response '200', 'post found' do
        # RSpec: Create a post and use its id for the test
        let(:id) { Post.create(user_id: @user.id, title: 'Sample', status: 1, content: 'Sample content').id }
        run_test!
      end

      response '404', 'post not found' do
        # RSpec: Use invalid id to test 404 response
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a post' do
      tags 'Posts'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :post_params, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          title: { type: :string },
          status: { type: :integer },
          content: { type: :string }
        },
        required: %w[user_id title content]
      }

      response '200', 'post updated' do
        let(:id) { Post.create(user_id: @user.id, title: 'Old Title', status: 0, content: 'Old content').id }
        let(:post_params) { { user_id: @user.id, title: 'Updated Title', status: 1, content: 'Updated content' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { Post.create(user_id: @user.id, title: 'Old Title', status: 0, content: 'Old content').id }
        let(:post_params) { { user_id: nil, title: '', content: '' } }
        run_test!
      end

      response '404', 'post not found' do
        let(:id) { 'invalid' }
        let(:post_params) { { user_id: @user.id, title: 'Updated Title', status: 1, content: 'Updated content' } }
        run_test!
      end
    end

    delete 'Deletes a post' do
      tags 'Posts'

      response '204', 'post deleted' do
        let(:id) { Post.create(user_id: @user.id, title: 'To be deleted', status: 0, content: 'Content').id }
        run_test!
      end

      response '404', 'post not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
