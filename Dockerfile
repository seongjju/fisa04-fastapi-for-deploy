# 1단계: 기본 파이썬 이미지 설정 (슬림한 버전으로 용량 절약!)
FROM python:3.10-slim AS base

# 2단계: 빌드 전용 이미지 만들기
FROM base AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /install

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir --prefix=/install/local -r requirements.txt

# 3단계: 최종 실행 이미지 구성
FROM base

WORKDIR /app

# 빌드한 패키지 복사
COPY --from=builder /install/local /usr/local

# 전체 코드 복사 (최상위 기준)
COPY . .

# ✅ 모델 파일 복사 (필요하면 명시적으로)
# COPY ./app/iris_model.joblib ./iris_model.joblib

# ✅ 템플릿 / 정적 파일 경로 통일 (FastAPI에서 찾을 수 있도록 루트로 복사)
COPY ./app/static ./static
COPY ./app/templates ./templates

# FastAPI 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]