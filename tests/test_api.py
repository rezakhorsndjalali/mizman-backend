from datetime import datetime, timedelta

from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)

BASE_URL = "/api/v1"


def test_complete_api_flow():
    """
    Test the main MIZMAN API flow:

    User
      ↓
    Business
      ↓
    Venue
      ↓
    Table
      ↓
    Room
      ↓
    Reservation
    """

    # =========================================================
    # 1. HEALTH CHECK
    # =========================================================

    response = client.get("/health")

    assert response.status_code == 200


    # =========================================================
    # 2. CREATE USER
    # =========================================================

    user_data = {
        "full_name": "Test User",
        "phone": "09120000000",
        "email": "test@mizman.com",
        "role": "customer",
    }

    response = client.post(
        f"{BASE_URL}/users/",
        json=user_data,
    )

    assert response.status_code == 200

    user = response.json()

    assert "id" in user
    assert user["full_name"] == user_data["full_name"]
    assert user["phone"] == user_data["phone"]

    user_id = user["id"]


    # =========================================================
    # 3. GET USERS
    # =========================================================

    response = client.get(
        f"{BASE_URL}/users/"
    )

    assert response.status_code == 200

    users = response.json()

    assert isinstance(users, list)


    # =========================================================
    # 4. CREATE BUSINESS
    # =========================================================

    business_data = {
        "owner_id": user_id,
        "name": "MIZMAN Test Cafe",
        "description": "Test business",
        "phone": "02100000000",
    }

    response = client.post(
        f"{BASE_URL}/businesses/",
        json=business_data,
    )

    assert response.status_code == 200

    business = response.json()

    assert "id" in business
    assert business["name"] == business_data["name"]
    assert business["owner_id"] == user_id

    business_id = business["id"]


    # =========================================================
    # 5. GET BUSINESSES
    # =========================================================

    response = client.get(
        f"{BASE_URL}/businesses/"
    )

    assert response.status_code == 200

    businesses = response.json()

    assert isinstance(businesses, list)


    # =========================================================
    # 6. CREATE VENUE
    # =========================================================

    venue_data = {
        "business_id": business_id,
        "name": "MIZMAN Main Branch",
        "venue_type": "cafe",
        "description": "Test cafe branch",
        "address": "Test Address",
        "city": "Tehran",
        "capacity": 100,
    }

    response = client.post(
        f"{BASE_URL}/venues/",
        json=venue_data,
    )

    assert response.status_code == 200

    venue = response.json()

    assert "id" in venue
    assert venue["name"] == venue_data["name"]
    assert venue["business_id"] == business_id

    venue_id = venue["id"]


    # =========================================================
    # 7. GET VENUES
    # =========================================================

    response = client.get(
        f"{BASE_URL}/venues/"
    )

    assert response.status_code == 200

    venues = response.json()

    assert isinstance(venues, list)


    # =========================================================
    # 8. CREATE TABLE
    # =========================================================

    table_data = {
        "venue_id": venue_id,
        "name": "Table 1",
        "capacity": 4,
        "price": 0,
    }

    response = client.post(
        f"{BASE_URL}/tables/",
        json=table_data,
    )

    assert response.status_code == 200

    table = response.json()

    assert "id" in table
    assert table["name"] == table_data["name"]
    assert table["venue_id"] == venue_id
    table_id = table["id"]


    # =========================================================
    # 9. GET TABLES
    # =========================================================

    response = client.get(
        f"{BASE_URL}/tables/"
    )

    assert response.status_code == 200

    tables = response.json()

    assert isinstance(tables, list)


    # =========================================================
    # 10. CREATE ROOM
    # =========================================================

    room_data = {
        "venue_id": venue_id,
        "name": "Game Room 1",
        "room_type": "mafia",
        "capacity": 12,
        "price": 500000,
    }

    response = client.post(
        f"{BASE_URL}/rooms/",
        json=room_data,
    )

    assert response.status_code == 200

    room = response.json()

    assert "id" in room
    assert room["name"] == room_data["name"]
    assert room["venue_id"] == venue_id

    room_id = room["id"]


    # =========================================================
    # 11. GET ROOMS
    # =========================================================

    response = client.get(
        f"{BASE_URL}/rooms/"
    )

    assert response.status_code == 200

    rooms = response.json()

    assert isinstance(rooms, list)


    # =========================================================
    # 12. CREATE RESERVATION
    # =========================================================

    start_time = datetime.now() + timedelta(days=1)
    end_time = start_time + timedelta(hours=2)

    reservation_data = {
        "user_id": user_id,
        "venue_id": venue_id,
        "table_id": table_id,
        "room_id": None,
        "start_time": start_time.isoformat(),
        "end_time": end_time.isoformat(),
        "guests": 4,
    }

    response = client.post(
        f"{BASE_URL}/reservations/",
        json=reservation_data,
    )

    assert response.status_code == 200

    reservation = response.json()

    assert "id" in reservation
    assert reservation["user_id"] == user_id
    assert reservation["venue_id"] == venue_id
    assert reservation["guests"] == 4

    reservation_id = reservation["id"]


    # =========================================================
    # 13. GET RESERVATIONS
    # =========================================================

    response = client.get(
        f"{BASE_URL}/reservations/"
    )

    assert response.status_code == 200

    reservations = response.json()

    assert isinstance(reservations, list)

    assert any(
        item["id"] == reservation_id
        for item in reservations
    )


    # =========================================================
    # FINAL
    # =========================================================

    print("\n")
    print("=" * 60)
    print("MIZMAN API TEST")
    print("=" * 60)
    print("Health          : PASSED")
    print("Users           : PASSED")
    print("Businesses      : PASSED")
    print("Venues          : PASSED")
    print("Tables          : PASSED")
    print("Rooms           : PASSED")
    print("Reservations    : PASSED")
    print("=" * 60)
    print("ALL MAIN API TESTS PASSED")
    print("=" * 60)