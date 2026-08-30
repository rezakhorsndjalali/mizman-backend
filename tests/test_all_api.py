from fastapi.testclient import TestClient
from app.main import app


client = TestClient(app)


def test_docs():
    response = client.get("/docs")
    assert response.status_code == 200


def test_openapi():
    response = client.get("/openapi.json")
    assert response.status_code == 200

    data = response.json()

    assert "paths" in data
    assert len(data["paths"]) > 0


def test_all_registered_routes():
    """
    بررسی می‌کند که تمام Routeهای ثبت‌شده در FastAPI
    واقعاً قابل دسترسی هستند و Backend خطای 500 نمی‌دهد.
    """

    ignored_paths = {
        "/docs",
        "/redoc",
        "/openapi.json",
    }

    tested_routes = 0

    for route in app.routes:

        # فقط Routeهای واقعی API
        if not hasattr(route, "methods"):
            continue

        path = route.path

        # مستندات را قبلاً جدا تست کردیم
        if path in ignored_paths:
            continue

        # Routeهایی که پارامتر Path دارند
        # مثل /users/{user_id}
        if "{" in path or "}" in path:
            continue

        methods = route.methods

        for method in methods:

            # فعلاً GET را به صورت واقعی تست می‌کنیم
            if method != "GET":
                continue

            response = client.get(path)

            tested_routes += 1

            # 500 یعنی مشکل واقعی در Backend
            assert response.status_code < 500, (
                f"Backend error on GET {path} "
                f"-> {response.status_code}"
            )

    assert tested_routes > 0