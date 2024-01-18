FROM python:3-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=80"]