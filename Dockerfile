FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY aircraft_monitor.py .

CMD ["python", "aircraft_monitor.py"]
