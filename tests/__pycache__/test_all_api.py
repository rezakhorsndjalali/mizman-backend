from fastapi.testclient import TestClient
from app.main import app


client = TestClient(app)


def test_all_get_apis():
    failed_apis = []

    for route in app.routes:

        # فقط APIهای GET
        if "GET" not in route.methods:
            continue

        # APIهایی که پارامتر اجباری داخل URL دارند فعلاً رد می‌کنیم
        if "{" in route.path:
            continue

        # بعضی Routeهای داخلی مثل docs و openapi را رد می‌کنیم
        if route.path in ["/docs", "/redoc", "/openapi.json"]:
            continue

        try:
            response = client.get(route.path)

            # 500 یعنی خطای واقعی سمت Backend
            if response.status_code >= 500:
                failed_apis.append(
                    f"{route.path} -> {response.status_code}"
                )

        except Exception as e:
            failed_apis.append(
                f"{route.path} -> {e}"
            )

    assert not failed_apis, (
        "Some APIs failed:\n" +
        "\n".join(failed_apis)
    )