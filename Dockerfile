# Use an official Python runtime as a parent image
FROM python:3.10

# 환경 변수 설정 (디버그 모드와 라이브 모드)
# ENV PYTHONUNBUFFERED 1
ARG ENVIRONMENT=production
ENV ENVIRONMENT=$ENVIRONMENT

# 설치
# RUN apt-get update && apt-get install -y mesa-libGL
RUN apt-get update && apt-get install -y libgl1-mesa-dev libosmesa6-dev


# 작업 디렉토리 생성
WORKDIR /app

# 필요한 패키지 설치
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 소스코드 복사
COPY . .

# Print environment variable (for debugging)
RUN echo "Environment: $ENVIRONMENT"

# Expose the port your app will run on
EXPOSE 8000

# 정적 파일 배포
# RUN if [ "$ENVIRONMENT" = "production" ]; then python manage.py collectstatic --noinput && ls -l /app/static; fi

# 엔트리 포인트 설정
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
CMD ["sh", "-c", "if [ \"$ENVIRONMENT\" = \"development\" ]; then python -m debugpy --listen 0.0.0.0:5678 manage.py runserver 0.0.0.0:8000; else gunicorn SilverLining.wsgi:application --bind 0.0.0.0:8000; fi"]
# gunicorn 연결 