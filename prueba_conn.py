import requests
try:
    response = requests.get("https://www.google.com", timeout=5)
    print(f"Conexión exitosa, status: {response.status_code}")
except Exception as e:
    print(f"Error general: {e}") 