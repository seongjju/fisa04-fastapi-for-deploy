# AWS를 사용한 FastAPI 기반 실시간 머신러닝 서빙 애플리케이션 클라우드 마이그레이션

이 실습 자료는 FastAPI 기반의 실시간 머신러닝 서빙 애플리케이션을 AWS 환경에 배포하는 과정을 다룹니다. Docker를 사용하여 이미지화하고, .env 파일을 통해 환경 변수 관리를 하며, EC2 인스턴스 상에서 실행할 수 있도록 구성합니다.

### 📁프로젝트 구조
```
├── app/
│   ├── main.py             # FastAPI 진입점
│   ├── ...
│   └── logs/               # 로그 저장 디렉토리 (호스트와 마운트)
├── .env                    # 환경 변수 파일
├── Dockerfile              # 컨테이너 이미지 정의
├── requirements.txt        # Python 의존성 명세
├── .gitignore              # Git 추적 제외 파일
├── .dockerignore           # Docker 이미지 제외 설정
└── README.md               # 현재 문서
```

### 🐳 이미지 빌드와 실행
```
$ docker build -t fisa04-fastapi .

# 윈도우인 경우
$ docker run -d -p 80:8000 --env-file .env -v %cd%/app/logs:/app/logs --name fastapi-docker fisa04-fastapi

# 리눅스에서
$ docker run -d -p 80:8000 --env-file .env -v ./app/logs:/app/logs --name fastapi-docker fisa04-fastapi
```

### 📡 EC2에서의 배포 참고사항
- 본인의 VPC를 생성하고 해당 VPC 안에 서버를 배치합니다.
- EC2 인스턴스는 보안 그룹에서 80번 포트 인바운드를 허용해야 합니다.
- EC2에 Docker(필요하다면 Git도) 설치되어 있어야 합니다.
- .env 파일과 로그 디렉토리는 EC2 내부에 위치해야 하며, docker run 시 경로를 정확히 지정해야 합니다.
- FastAPI 애플리케이션 로그는 ./app/logs 디렉토리에 저장되며, 컨테이너 외부 볼륨으로 마운트되어 유지됩니다.

### 🔎 접속 확인
FastAPI 서버 실행 후, 브라우저에서 EC2 인스턴스의 퍼블릭 IP를 입력하면 기본 라우트에 접속할 수 있습니다.

```
http://http://52.79.62.62:8000/
http://http://52.79.62.62:8000/docs  # Swagger 문서
```

### 결과사진
<img width="1424" alt="image" src="https://github.com/user-attachments/assets/2355d6d3-d36f-4469-995c-d0283b42fa96" />
<img width="1424" alt="image" src="https://github.com/user-attachments/assets/4f743132-6613-428b-b30c-2bc02ee0afc8" />

#### 로그 확인
<img width="803" alt="image" src="https://github.com/user-attachments/assets/4d055113-609a-4b00-a7ce-054c93c3798a" />





### 🛠 트러블슈팅 & 향후 개선

### 1) RDS 연결 오류
#### 원인
- MySQL RDS 엔드포인트 연결 실패
- DB 미생성
- 보안그룹 인바운드 허용 안함

#### 해결방법
- MySQL 접속 후 DB 생성

### 2) 모듈 ImportError
#### 원인
- FastAPI 구조에서 상대경로 import 문제

#### 해결방법
- app 디렉토리 기준으로 import 경로 수정

#### 향후 개선
GitHub Actions통한 자동화
