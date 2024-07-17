require 'swagger_helper'

describe 'Exam API' do

  path '/api/v1/exams/available_times' do
    get '예약 가능시간 조회' do
      tags 'Exam'
      security [{ 'bearerAuth' => [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :date, in: :query, schema: {
        type: :string,
        format: :date,
        default: '2024-09-15',
      }

      response '201', 'success' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   start_date_time: { type: :string, default: '2024-09-15 12:00:00' },
                   end_date_time: { type: :string, default: '2024-09-15 14:00:00' },
                   total_number_of_applicants_confirmed_between: { type: :integer, default: 10000 },
                   status: { type: :string, default: 'available' },
                 }
               }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end

  path '/api/v1/exams/request' do
    post '시험 예약 신청' do
      tags 'Exam'
      # here
      security [{ 'bearerAuth' => [] }]
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

  path '/api/v1/exams' do
    get '예약 조회' do
      tags 'Exam'
      security [{ 'bearerAuth' => [] }]
      produces 'application/json'
      parameter name: 'page', in: :query, schema: {
        type: :integer, default: 0
      }
      parameter name: 'page_size', in: :query, schema: {
        type: :integer, default: 10
      }

      response '200', 'success' do
        schema type: :object,
               properties: {
                 items: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, default: 1 },
                       title: { type: :string, default: '코딩테스트' },
                     }
                   }
                 },
                 page: {
                   type: :object,
                   properties: {
                     total_pages: { type: :integer },
                     current_page: { type: :integer },
                     total_count: { type: :integer },
                     next_page: { type: :integer },
                     prev_page: { type: :integer },
                   }
                 }
               }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end

  path '/api/v1/exams/{exam_id}' do
    patch '예약 변경' do
      tags 'Exam'
      security [{ 'bearerAuth' => [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :update_exam, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, default: '코딩테스트 1 (변경)' },
          start_date_time: { type: :string, default: '2024-09-15 12:00:00' },
          end_date_time: { type: :string, default: '2024-09-15 14:00:00' },
          number_of_applicants: { type: :integer },
        }
      }
      parameter name: 'exam_id', in: :path, schema: {
        type: :integer
      }

      response '200', 'success' do
        schema type: :object,
               properties: {
                 exam_id: { type: :integer, default: 1 },
                 title: { type: :string, default: '코딩테스트 1 (변경)' },
                 start_date_time: { type: :string, default: '2024-09-15 12:00:00' },
                 end_date_time: { type: :string, default: '2024-09-15 14:00:00' },
                 number_of_applicants: { type: :integer },
                 status: { type: :string, enum: ['requested', 'confirmed'] },
               }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end

  path '/api/v1/exams/{exam_id}/confirm' do
    patch '예약 확정' do
      tags 'Exam'
      security [{ 'bearerAuth' => [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'exam_id', in: :path, schema: {
        type: :integer
      }

      response '200', 'success' do
        schema type: :object,
               properties: {
                 exam_id: { type: :integer, default: 1 },
                 title: { type: :string, default: '코딩테스트 1' },
                 start_date_time: { type: :string, default: '2024-09-15 12:00:00' },
                 end_date_time: { type: :string, default: '2024-09-15 14:00:00' },
                 number_of_applicants: { type: :integer },
                 status: { type: :string, enum: ['requested', 'confirmed'] },
               }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end

  path '/api/v1/exams/{exam_id}' do
    delete '예약 삭제' do
      tags 'Exam'
      security [{ 'bearerAuth' => [] }]
      produces 'application/json'
      parameter name: 'exam_id', in: :path, schema: {
        type: :integer
      }

      response '200', 'success' do
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end
  end


end