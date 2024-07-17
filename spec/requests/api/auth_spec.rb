
require 'swagger_helper'

describe 'Auth API' do

  path '/api/v1/auth/login' do
    post '로그인' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :login, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, default: 'grepp@grepp.com' },
          password: { type: :string, default: 'password' }
        },
        required: ['email', 'password']
      }
      security [Bearer: {}]
      response '200', 'successful login' do
        schema type: :object,
               properties: {
                 id: { type: :integer, default: 1 },
                 email: { type: :string, default: 'grepp@grepp.com' },
                 name: { type: :string, default: '김그렙' },
                 token: { type: :string },
               },
               required: ['id', 'email', 'name', 'token']

        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end

  path '/api/v1/auth/sign_up' do
    post '회원가입' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :sign_up, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, default: 'grepp@grepp.com' },
          name: { type: :string, default: '김그렙' },
          role: { type: :string, default: 'user' },
          password: { type: :string, default: 'password' }
        },
        required: ['email', 'name', 'role', 'password']
      }

      response '201', 'user created' do
        schema type: :object,
               properties: {
                 id: { type: :integer, default: 1 },
                 email: { type: :string, default: 'grepp@grepp.com' },
                 name: { type: :string, default: '김그렙' },
                 role: { type: :string, default: 'user' }
               },
               required: ['id', 'email', 'name', 'role']

        run_test!
      end

      response '400', 'bad request' do
        run_test!
      end
    end
  end

end