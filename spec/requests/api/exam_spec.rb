
require 'swagger_helper'

describe 'Exam API' do

  path '/api/v1/exams/request' do
    post '시험 예약 신청' do
      tags 'Exam'
      # here
      security [ { 'bearerAuth' => [] } ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :reserve_request, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, default: '코딩테스트' },
          start_date_time: { type: :string, default: '2024-09-15 12:00:00' },
          end_date_time: { type: :string, default: '2024-09-15 14:00:00' },
          number_of_applicants: { type: :integer, default: 10000 },
        },
        required: ['title', 'start_date_time', 'end_date_time', 'number_of_applicants']
      }

      response '201', 'successful created' do
        schema type: :object,
               properties: {
                 id: { type: :integer, default: 1 },
                 title: { type: :string, default: '코딩테스트' },
                 reserved_user_id: { type: :integer, default: 1 },
                 start_date_time: { type: :string, default: '2024-09-15 12:00:00' },
                 end_date_time: { type: :string, default: '2024-09-15 14:00:00' },
                 number_of_applicants: { type: :integer },
               },
               required: ['title', 'start_date_time', 'end_date_time', 'number_of_applicants']

        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end

end