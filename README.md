
# grepp 백엔드 엔지니어 과제 (이진석)


## 🏠 Overview


**소감**

grepp 백엔드 과제를 수행하였다. ruby 기반 프레임워크는 해본적이 없어서 쉽지 않았지만 기존 spring 프레임워크에 존재하는 것들이 대부분 존재한다고 생각했기에 대체할 수 있는
것들을 찾아보면서 과제를 수행하였다. 색다른 경험이 된것 같다. 

**테스트**

테스트 코드를 먼저 작성하고 이후에 컨트롤러를 작성하였다. 테스트 기반으로 정교하게 동작하는 api를 만들고 싶었다.

**아쉬운점**

ruby 언어에 대한 이해가 아직 부족하기에 조금 더 깊이있는 이해를 할 수 있다면 좋겠다는 생각이 들었다.

## 🏛️ Domain

### User (사용자)
| column     | description      |
|------------|------------------|
| id         | primary key      |
| email      | 이메일              |
| name       | 이름               |
| role       | 역할 (admin, user) |
| password   | 비밀번호             |
| created_at | 생성시간             |
| updated_at | 최종 업데이트 시간       |


### Exam (시험)
| column               | description |
|----------------------|-------------|
| id                   | primary key |
| title                | 시험 타이틀      |
| start_date_time      | 시작시간        |
| end_date_time        | 마감시간        |
| number_of_applicants | 예상 응시인원     |
| created_at           | 생성시간        |
| updated_at           | 최종 업데이트 시간  |


## 🎢 Tech Stack

Ruby 3.3.4

Rails 7.1.3.4

postgresql

## 🐟 Routes

```ruby
get "hello" => "hello#hello" # hello
post "/api/v1/auth/sign_up" => "auth#sign_up" # 회원가입
post "/api/v1/auth/login" => "auth#login" # 로그인
get "/api/v1/exams" => "exam#get_exams" # 시험 예약 조회
get "/api/v1/exams/available_times" => "exam#get_available_time" # 예약 가능 시간 확인
post "/api/v1/exams/request" => "exam#reserve_request" # 예약 신청
patch "/api/v1/exams/:exam_id/confirm" => "exam#confirm" # 예약 확정
patch "/api/v1/exams/:exam_id" => "exam#update_exam" # 예약 변경
delete "/api/v1/exams/:exam_id" => "exam#delete_exam" # 예약 삭제
```

## ⛲ Database

docker 폴더내에 docker-compose.yml을 이용하면 postgresql을 올릴 수 있다.

```dockerfile
# compose 파일 버전
version: "3"
services: 
  # 서비스 명
  postgresql:
    # 사용할 이미지
    image: postgres
    # 컨테이너 실행 시 재시작
    restart: always
    # 컨테이너명 설정
    container_name: postgres
    # 접근 포트 설정 (컨테이너 외부:컨테이너 내부)
    ports:
      - "5432:5432"
    # 환경 변수 설정
    environment: 
      # PostgreSQL 계정 및 패스워드 설정 옵션
      POSTGRES_USER: root
      POSTGRES_PASSWORD: root
    # 볼륨 설정
    volumes:
      - ./data/postgres/:/var/lib/postgresql/data

  # 서비스 명
  pgadmin:
    # 사용할 이미지
    image: dpage/pgadmin4
    # 컨테이너 실행 시 재시작
    restart: always
    # 컨테이너명 설정
    container_name: pgadmin4
    # 접근 포트 설정 (컨테이너 외부:컨테이너 내부)
    ports:
      - "5050:80"
    # 환경 변수 설정
    environment:
      PGADMIN_DEFAULT_EMAIL: pgadmin4@pgadmin.org
      PGADMIN_DEFAULT_PASSWORD: password
    # 볼륨 설정
    volumes:
      - ./data/pgadmin/:/var/lib/pgadmin

```

## 👷 Todo
 
- [x] 로그인
- [x] 회원가입
- [x] 예약가능 시간 조회
- [x] 예약신청
  - [x] 고객
- [x] 예약조회
  - [x] 고객
  - [x] 어드민
- [x] 예약확정 (어드민)
- [x] 예약수정
  - [x] 고객
  - [x] 어드민
- [x] 예약삭제
  - [x] 고객
  - [x] 어드민