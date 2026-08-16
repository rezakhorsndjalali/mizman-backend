Reza Khorsnd, [8/16/2026 9:57 PM]
# MIZMAN Backend
#
# Smart Café, Restaurant & Entertainment Reservation Platform
#
# Backend technology:
# Python + FastAPI
#
# Database:
# PostgreSQL
#
# ORM:
# SQLAlchemy
#
# Migration:
# Alembic
#
# Cache:
# Redis
#
# Background Tasks:
# Celery
#
# Authentication:
# JWT + OTP
#
# Testing:
# Pytest + HTTPX
#
# Containerization:
# Docker + Docker Compose



# OVERVIEW

"""
MIZMAN Backend is the server-side application of the MIZMAN
platform.

It provides RESTful APIs for:

- Customers
- Cafés
- Restaurants
- Entertainment venues
- Business owners
- Administrators

The backend is responsible for authentication, business
management, venue management, availability, reservations,
payments, reviews, notifications, search, discounts,
and administration.
"""

# BACKEND RESPONSIBILITIES

BACKEND_RESPONSIBILITIES = [
    "User authentication",
    "User management",
    "Business registration",
    "Business verification",
    "Branch management",
    "Venue management",
    "Table management",
    "Room management",
    "Availability management",
    "Reservation management",
    "Payment processing",
    "Reviews and ratings",
    "Favorites",
    "Notifications",
    "Search and filtering",
    "Discounts",
    "Administration",
    "Business analytics",
]


# TECHNOLOGY STACK

TECHNOLOGY_STACK = {
    "language": "Python 3.12+",
    "framework": "FastAPI",
    "database": "PostgreSQL",
    "orm": "SQLAlchemy",
    "migration": "Alembic",
    "validation": "Pydantic",
    "authentication": [
        "JWT",
        "OAuth2",
        "OTP",
    ],
    "cache": "Redis",
    "background_tasks": "Celery",
    "server": "Uvicorn",
    "testing": [
        "Pytest",
        "HTTPX",
    ],
    "containerization": [
        "Docker",
        "Docker Compose",
    ],
}

# ARCHITECTURE

ARCHITECTURE = """
Client
   |
   v
FastAPI Router
   |
   v
Service Layer
   |
   v
Repository Layer
   |
   v
SQLAlchemy
   |
   v
PostgreSQL
"""

# PROJECT STRUCTURE

PROJECT_STRUCTURE = """
backend/
│
├── app/
│   ├── main.py
│   │
│   ├── core/
│   │   ├── init.py
│   │   ├── config.py
│   │   ├── database.py
│   │   ├── security.py
│   │   ├── exceptions.py
│   │   └── logging.py
│   │
│   ├── api/
│   │   ├── init.py
│   │   ├── dependencies.py
│   │   │
│   │   └── v1/
│   │       ├── init.py
│   │       ├── router.py
│   │       │
│   │       └── endpoints/
│   │           ├── init.py
│   │           ├── auth.py
│   │           ├── users.py
│   │           ├── businesses.py
│   │           ├── branches.py
│   │           ├── venues.py
│   │           ├── tables.py
│   │           ├── rooms.py
│   │           ├── reservations.py
│   │           ├── availability.py
│   │           ├── payments.py
│   │           ├── reviews.py
│   │           ├── favorites.py
│   │           ├── notifications.py
│   │           ├── search.py
│   │           ├── categories.py
│   │           ├── discounts.py
│   │           └── admin.py
│   │
│   ├── models/
│   ├── schemas/
│   ├── services/
│   ├── repositories/
│   ├── utils/
│   └── integrations/
│
├── alembic/
│   ├── versions/
│   ├── env.py
│   └── script.py.mako
│
├── tests/
│   ├── unit/
│   ├── integration/
│   └── api/
│
├── scripts/
│   ├── seed.py
│   └── create_admin.py
│
├── .env
├── .env.example
├── .gitignore
├── alembic.ini
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
└── README.md
"""

# API VERSIONING

API_VERSION = "/api/v1/"

API_EXAMPLES = [
    "GET /api/v1/venues",
    "GET /api/v1/venues/{venue_id}",
    "POST /api/v1/reservations",
]

# AUTHENTICATION API

AUTH_ENDPOINTS = [
    "POST /api/v1/auth/register",
    "POST /api/v1/auth/login",
    "POST /api/v1/auth/logout",
    "POST /api/v1/auth/refresh",
    "POST /api/v1/auth/otp/request",
    "POST /api/v1/auth/otp/verify",
]

# USER API

USER_ENDPOINTS = [
    "GET /api/v1/users/me",
    "PUT /api/v1/users/me",
    "DELETE /api/v1/users/me",
]

# BUSINESS API

BUSINESS_ENDPOINTS = [
    "POST /api/v1/businesses",
    "GET /api/v1/businesses",
    "GET /api/v1/businesses/{business_id}",
    "PUT /api/v1/businesses/{business_id}",
]


# VENUE API

VENUE_ENDPOINTS = [
    "POST /api/v1/venues",
    "GET /api/v1/venues",
    "GET /api/v1/venues/{venue_id}",
    "PUT /api/v1/venues/{venue_id}",
]


# TABLE API

TABLE_ENDPOINTS = [
    "POST /api/v1/venues/{venue_id}/tables",
    "GET /api/v1/venues/{venue_id}/tables",
    "PUT /api/v1/tables/{table_id}",
    "DELETE /api/v1/tables/{table_id}",
]


# ROOM API

ROOM_ENDPOINTS = [
    "POST /api/v1/venues/{venue_id}/rooms",
    "GET /api/v1/venues/{venue_id}/rooms",
    "PUT /api/v1/rooms/{room_id}",
    "DELETE /api/v1/rooms/{room_id}",
]

# AVAILABILITY API

AVAILABILITY_ENDPOINTS = [
    "GET /api/v1/venues/{venue_id}/availability",
    "GET /api/v1/tables/{table_id}/availability",
    "GET /api/v1/rooms/{room_id}/availability",
]

# RESERVATION API

RESERVATION_ENDPOINTS = [
    "POST /api/v1/reservations",
    "GET /api/v1/reservations",
    "GET /api/v1/reservations/{reservation_id}",
    "PATCH /api/v1/reservations/{reservation_id}/cancel",
]


# PAYMENT API

PAYMENT_ENDPOINTS = [
    "POST /api/v1/payments",
    "GET /api/v1/payments/{payment_id}",
    "POST /api/v1/payments/{payment_id}/verify",
]


# REVIEW API

REVIEW_ENDPOINTS = [
    "POST /api/v1/venues/{venue_id}/reviews",
    "GET /api/v1/venues/{venue_id}/reviews",
    "PUT /api/v1/reviews/{review_id}",
    "DELETE /api/v1/reviews/{review_id}",
]


# RESERVATION FLOW

RESERVATION_FLOW = """
Customer
   |
   v
Search Venue
   |
   v
Select Date & Time
   |
   v
Check Availability
   |
   v
Select Table / Room
   |
   v
Create Reservation
   |
   v
Payment
   |
   v
Payment Verification
   |
   v
Reservation Confirmation
   |
   v
Notification
"""


# DOUBLE BOOKING PREVENTION

DOUBLE_BOOKING_RULES = [
    "Venue availability must be checked",
    "Table availability must be checked",

Reza Khorsnd, [8/16/2026 9:57 PM]
"Room availability must be checked",
    "Date must be validated",
    "Start time must be validated",
    "End time must be validated",
    "Existing reservations must be checked",
    "Reservation status must be checked",
    "Capacity must be validated",
]

"""
The reservation process must use database transactions and
appropriate locking or constraints where required.
"""


# AUTHENTICATION

AUTHENTICATION_ROLES = [
    "Customer",
    "Business Owner",
    "Administrator",
]

AUTHENTICATION_FLOW = """
Register / Login
       |
       v
Validate Credentials
       |
       v
Generate Access Token
       |
       v
Client Stores Token
       |
       v
Authenticated API Request
"""


# ENVIRONMENT VARIABLES

ENVIRONMENT_VARIABLES = {
    "APP_NAME": "MIZMAN",
    "APP_ENV": "development",
    "DEBUG": True,
    "DATABASE_URL": (
        "postgresql+asyncpg://"
        "user:password@localhost:5432/mizman"
    ),
    "JWT_SECRET_KEY": "your-secret-key",
    "JWT_ALGORITHM": "HS256",
    "ACCESS_TOKEN_EXPIRE_MINUTES": 30,
    "REDIS_URL": "redis://localhost:6379/0",
}


# INSTALLATION

INSTALLATION_COMMANDS = [
    "git clone <repository-url>",
    "cd mizman/backend",
    "python -m venv .venv",
    "source .venv/bin/activate",
    "pip install -r requirements.txt",
]


# DATABASE SETUP

DATABASE_COMMANDS = [
    "alembic upgrade head",
    'alembic revision --autogenerate -m "migration message"',
]


# RUN SERVER

RUN_SERVER_COMMAND = "uvicorn app.main:app --reload"

SERVER_URL = "http://127.0.0.1:8000"


# API DOCUMENTATION

API_DOCUMENTATION = {
    "swagger": "http://127.0.0.1:8000/docs",
    "redoc": "http://127.0.0.1:8000/redoc",
}


# TESTING

TEST_COMMANDS = [
    "pytest",
    "pytest tests/unit",
    "pytest tests/integration",
    "pytest tests/api",
]


# DOCKER

DOCKER_COMMANDS = [
    "docker compose up --build",
    "docker compose down",
]


# DEVELOPMENT PRINCIPLES

DEVELOPMENT_PRINCIPLES = [
    "Clean architecture",
    "Separation of concerns",
    "Modular design",
    "RESTful API design",
    "Strong validation",
    "Secure authentication",
    "Database integrity",
    "Test-driven development where appropriate",
    "Clear documentation",
    "Environment-based configuration",
    "Scalable architecture",
]


# SECURITY

SECURITY_FEATURES = [
    "Password hashing",
    "JWT authentication",
    "Role-based authorization",
    "Input validation",
    "Rate limiting",
    "Secure HTTP configuration",
    "Database transaction protection",
    "Payment verification",
    "Secure environment variables",
    "Logging",
    "Error handling",
    "Database backups",
]


# DEVELOPMENT ROADMAP

DEVELOPMENT_ROADMAP = {

Reza Khorsnd, [8/16/2026 9:57 PM]
"Phase 1 - Foundation": [
        "FastAPI project setup",
        "PostgreSQL connection",
        "SQLAlchemy configuration",
        "Alembic configuration",
        "Environment configuration",
        "Project structure",
        "Basic API configuration",
    ],

    "Phase 2 - Authentication": [
        "User model",
        "Registration",
        "Login",
        "JWT",
        "OTP",
        "Roles",
        "Permissions",
    ],

    "Phase 3 - Business Management": [
        "Business registration",
        "Business verification",
        "Branch management",
        "Business profile",
    ],

    "Phase 4 - Venue Management": [
        "Venue management",
        "Tables",
        "Rooms",
        "Game rooms",
        "Facilities",
        "Capacity",
        "Pricing",
    ],

    "Phase 5 - Availability": [
        "Working hours",
        "Time slots",
        "Table availability",
        "Room availability",
        "Conflict detection",
    ],

    "Phase 6 - Reservations": [
        "Reservation creation",
        "Reservation confirmation",
        "Cancellation",
        "Reservation history",
        "Double-booking prevention",
    ],

    "Phase 7 - Payments": [
        "Payment creation",
        "Payment verification",
        "Deposits",
        "Refunds",
        "Transaction history",
    ],

    "Phase 8 - Search": [
        "Search",
        "Filtering",
        "Sorting",
        "Location-based search",
        "Availability filtering",
    ],

    "Phase 9 - Reviews": [
        "Ratings",
        "Reviews",
        "Verified reviews",
        "Moderation",
    ],

    "Phase 10 - Notifications": [
        "Reservation notifications",
        "Payment notifications",
        "Cancellation notifications",
        "Reminder notifications",
    ],

    "Phase 11 - Administration": [
        "Admin APIs",
        "User management",
        "Business verification",
        "Reservation monitoring",
        "Reports",
    ],

    "Phase 12 - Testing and Deployment": [
        "Unit tests",
        "Integration tests",
        "API tests",
        "Security testing",
        "Docker",
        "Production deployment",
        "Monitoring",
    ],
}


# PROJECT STATUS

PROJECT_STATUS = "In Development"

PROJECT_DESCRIPTION = """
The MIZMAN backend is currently under active development.

The system is being implemented incrementally, with each
module designed, implemented, tested, and documented before
moving to the next stage.
"""


# FUTURE IMPROVEMENTS

FUTURE_IMPROVEMENTS = [
    "Advanced recommendation engine",
    "AI-powered venue recommendations",
    "Natural language search",
    "Dynamic pricing",
    "Loyalty system",
    "Referral system",
    "Advanced business analytics",
    "Real-time reservation updates",
    "WebSocket notifications",
    "Multi-language support",
    "Multi-currency support",
]


# LICENSE

LICENSE = """
License information will be added when the project's
licensing strategy is finalized.
"""


# MIZMAN BACKEND

TAGLINE = "Built with Python and FastAPI"

SLOGAN = "Discover. Choose. Book. Experience."