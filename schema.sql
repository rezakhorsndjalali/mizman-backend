-- ============================================================
-- MIZMAN DATABASE
-- PostgreSQL Database Schema
-- ============================================================

-- ============================================================
-- EXTENSIONS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";


-- ============================================================
-- ENUM TYPES
-- ============================================================

CREATE TYPE user_role AS ENUM (
    'CUSTOMER',
    'BUSINESS_OWNER',
    'ADMIN'
);

CREATE TYPE business_status AS ENUM (
    'PENDING',
    'ACTIVE',
    'SUSPENDED',
    'REJECTED'
);

CREATE TYPE venue_type AS ENUM (
    'CAFE',
    'RESTAURANT',
    'GAME_ROOM',
    'VIP_ROOM',
    'PRIVATE_HALL',
    'OUTDOOR_AREA',
    'OTHER'
);

CREATE TYPE reservation_status AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED',
    'EXPIRED'
);

CREATE TYPE payment_method AS ENUM (
    'ONLINE',
    'CASH',
    'CARD'
);

CREATE TYPE payment_status AS ENUM (
    'PENDING',
    'SUCCESS',
    'FAILED',
    'REFUNDED'
);

CREATE TYPE review_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);

CREATE TYPE media_type AS ENUM (
    'IMAGE',
    'VIDEO'
);

CREATE TYPE discount_type AS ENUM (
    'PERCENTAGE',
    'FIXED_AMOUNT'
);

CREATE TYPE notification_type AS ENUM (
    'RESERVATION',
    'PAYMENT',
    'CANCELLATION',
    'REMINDER',
    'PROMOTION',
    'SYSTEM'
);

CREATE TYPE room_type AS ENUM (
    'MAFIA',
    'GOL_YA_POCH',
    'VIP',
    'BIRTHDAY',
    'PRIVATE',
    'OTHER'
);


-- ============================================================
-- USERS
-- ============================================================

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    phone VARCHAR(20) NOT NULL UNIQUE,

    email VARCHAR(150) UNIQUE,

    password_hash VARCHAR(255),

    role user_role NOT NULL DEFAULT 'CUSTOMER',

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    is_verified BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ============================================================
-- BUSINESSES
-- ============================================================

CREATE TABLE businesses (
    id BIGSERIAL PRIMARY KEY,

    owner_id BIGINT NOT NULL,

    name VARCHAR(150) NOT NULL,

    description TEXT,

    phone VARCHAR(20),

    logo_url VARCHAR(500),

    status business_status NOT NULL DEFAULT 'PENDING',

    is_verified BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_business_owner
        FOREIGN KEY (owner_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- ============================================================
-- BRANCHES
-- ============================================================

CREATE TABLE branches (
    id BIGSERIAL PRIMARY KEY,

    business_id BIGINT NOT NULL,

    name VARCHAR(150) NOT NULL,

    phone VARCHAR(20),

    address TEXT NOT NULL,

    city VARCHAR(100) NOT NULL,

    latitude DECIMAL(10, 7),

    longitude DECIMAL(10, 7),

    postal_code VARCHAR(20),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_branch_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(id)
        ON DELETE CASCADE
);


-- ============================================================
-- VENUES
-- ============================================================

CREATE TABLE venues (
    id BIGSERIAL PRIMARY KEY,

    branch_id BIGINT NOT NULL,

    name VARCHAR(150) NOT NULL,

    venue_type venue_type NOT NULL,

    description TEXT,

    capacity INTEGER NOT NULL DEFAULT 1,

    base_price NUMERIC(12, 2) NOT NULL DEFAULT 0,

    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',

    is_active BOOLEAN NOT NULL DEFAULT TRUE,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_venue_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(id)
        ON DELETE CASCADE,

    CONSTRAINT venue_capacity_positive
        CHECK (capacity > 0),

    CONSTRAINT venue_base_price_positive
        CHECK (base_price >= 0)
);


-- ============================================================
-- TABLES
-- ============================================================

CREATE TABLE tables (
    id BIGSERIAL PRIMARY KEY,

    venue_id BIGINT NOT NULL,

    name VARCHAR(50) NOT NULL,

    capacity INTEGER NOT NULL DEFAULT 2,

    price NUMERIC(12, 2) NOT NULL DEFAULT 0,

    position VARCHAR(100),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_table_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE,

    CONSTRAINT table_capacity_positive
        CHECK (capacity > 0),

    CONSTRAINT table_price_positive
        CHECK (price >= 0)
);


-- ============================================================
-- ROOMS
-- ============================================================

CREATE TABLE rooms (
    id BIGSERIAL PRIMARY KEY,

    venue_id BIGINT NOT NULL,

    name VARCHAR(100) NOT NULL,

    room_type room_type NOT NULL,

    description TEXT,

    capacity INTEGER NOT NULL DEFAULT 4,

    price NUMERIC(12, 2) NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_room_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE,

    CONSTRAINT room_capacity_positive
        CHECK (capacity > 0),

    CONSTRAINT room_price_positive
        CHECK (price >= 0)
);


-- ============================================================
-- RESERVATIONS
-- ============================================================

CREATE TABLE reservations (
    id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL,

    venue_id BIGINT NOT NULL,

    table_id BIGINT,

    room_id BIGINT,

    reservation_code VARCHAR(30) NOT NULL UNIQUE,

    start_time TIMESTAMPTZ NOT NULL,

    end_time TIMESTAMPTZ NOT NULL,

    guests INTEGER NOT NULL DEFAULT 1,

    status reservation_status NOT NULL DEFAULT 'PENDING',

    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_reservation_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservation_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservation_table
        FOREIGN KEY (table_id)
        REFERENCES tables(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservation_room
        FOREIGN KEY (room_id)
        REFERENCES rooms(id)
        ON DELETE RESTRICT,

    CONSTRAINT reservation_valid_time
        CHECK (end_time > start_time),

    CONSTRAINT reservation_guests_positive
        CHECK (guests > 0),

    CONSTRAINT reservation_amount_positive
        CHECK (total_amount >= 0),

    CONSTRAINT reservation_resource_required
        CHECK (
            table_id IS NOT NULL
            OR room_id IS NOT NULL
        ),

    CONSTRAINT reservation_single_resource
        CHECK (
            NOT (
                table_id IS NOT NULL
                AND room_id IS NOT NULL
            )
        )
);


-- ============================================================
-- PAYMENTS
-- ============================================================

CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,

    reservation_id BIGINT NOT NULL,

    amount NUMERIC(12, 2) NOT NULL,

    currency VARCHAR(10) NOT NULL DEFAULT 'IRR',

    payment_method payment_method NOT NULL DEFAULT 'ONLINE',

    status payment_status NOT NULL DEFAULT 'PENDING',

    transaction_id VARCHAR(150),gateway_reference VARCHAR(150),

    paid_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_payment_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservations(id)
        ON DELETE RESTRICT,

    CONSTRAINT payment_amount_positive
        CHECK (amount > 0)
);


-- ============================================================
-- REVIEWS
-- ============================================================

CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL,

    venue_id BIGINT NOT NULL,

    reservation_id BIGINT UNIQUE,

    rating SMALLINT NOT NULL,

    comment TEXT,

    status review_status NOT NULL DEFAULT 'PENDING',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_review_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_review_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservations(id)
        ON DELETE SET NULL,

    CONSTRAINT review_rating_range
        CHECK (rating BETWEEN 1 AND 5)
);


-- ============================================================
-- FAVORITES
-- ============================================================

CREATE TABLE favorites (
    id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL,

    venue_id BIGINT NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_favorite_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_favorite_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_user_favorite
        UNIQUE (user_id, venue_id)
);


-- ============================================================
-- CATEGORIES
-- ============================================================

CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL,

    slug VARCHAR(100) NOT NULL UNIQUE,

    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ============================================================
-- VENUE CATEGORIES
-- ============================================================

CREATE TABLE venue_categories (
    id BIGSERIAL PRIMARY KEY,

    venue_id BIGINT NOT NULL,

    category_id BIGINT NOT NULL,

    CONSTRAINT fk_venue_category_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_venue_category_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_venue_category
        UNIQUE (venue_id, category_id)
);


-- ============================================================
-- FACILITIES
-- ============================================================

CREATE TABLE facilities (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL UNIQUE,

    icon VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ============================================================
-- VENUE FACILITIES
-- ============================================================

CREATE TABLE venue_facilities (
    id BIGSERIAL PRIMARY KEY,

    venue_id BIGINT NOT NULL,

    facility_id BIGINT NOT NULL,

    CONSTRAINT fk_venue_facility_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_venue_facility_facility
        FOREIGN KEY (facility_id)
        REFERENCES facilities(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_venue_facility
        UNIQUE (venue_id, facility_id)
);


-- ============================================================
-- BUSINESS HOURS
-- ============================================================

CREATE TABLE business_hours (
    id BIGSERIAL PRIMARY KEY,

    venue_id BIGINT NOT NULL,day_of_week SMALLINT NOT NULL,

    opening_time TIME,

    closing_time TIME,

    is_closed BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_business_hours_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE,

    CONSTRAINT day_of_week_range
        CHECK (day_of_week BETWEEN 0 AND 6),

    CONSTRAINT unique_venue_day
        UNIQUE (venue_id, day_of_week)
);


-- ============================================================
-- DISCOUNTS
-- ============================================================

CREATE TABLE discounts (
    id BIGSERIAL PRIMARY KEY,

    venue_id BIGINT NOT NULL,

    code VARCHAR(50) NOT NULL UNIQUE,

    discount_type discount_type NOT NULL,

    discount_value NUMERIC(12, 2) NOT NULL,

    min_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    start_date TIMESTAMPTZ NOT NULL,

    end_date TIMESTAMPTZ NOT NULL,

    usage_limit INTEGER,

    used_count INTEGER NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_discount_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE,

    CONSTRAINT discount_value_positive
        CHECK (discount_value > 0),

    CONSTRAINT discount_min_amount_positive
        CHECK (min_amount >= 0),

    CONSTRAINT discount_valid_dates
        CHECK (end_date > start_date),

    CONSTRAINT discount_usage_valid
        CHECK (
            usage_limit IS NULL
            OR usage_limit > 0
        ),

    CONSTRAINT discount_used_valid
        CHECK (used_count >= 0)
);


-- ============================================================
-- NOTIFICATIONS
-- ============================================================

CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL,

    title VARCHAR(150) NOT NULL,

    message TEXT NOT NULL,

    type notification_type NOT NULL,

    reference_id BIGINT,

    is_read BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_notification_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- ============================================================
-- MEDIA
-- ============================================================

CREATE TABLE media (
    id BIGSERIAL PRIMARY KEY,

    venue_id BIGINT NOT NULL,

    url VARCHAR(500) NOT NULL,

    type media_type NOT NULL DEFAULT 'IMAGE',

    sort_order INTEGER NOT NULL DEFAULT 0,

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_media_venue
        FOREIGN KEY (venue_id)
        REFERENCES venues(id)
        ON DELETE CASCADE
);


-- ============================================================
-- RESERVATION GUESTS
-- ============================================================

CREATE TABLE reservation_guests (
    id BIGSERIAL PRIMARY KEY,

    reservation_id BIGINT NOT NULL,

    full_name VARCHAR(100) NOT NULL,

    phone VARCHAR(20),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_guest_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservations(id)
        ON DELETE CASCADE
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_business_owner
    ON businesses(owner_id);

CREATE INDEX idx_branch_business
    ON branches(business_id);

CREATE INDEX idx_branch_city
    ON branches(city);

CREATE INDEX idx_venue_branch
    ON venues(branch_id);

CREATE INDEX idx_venue_type
    ON venues(venue_type);

CREATE INDEX idx_table_venue
    ON tables(venue_id);

CREATE INDEX idx_room_venue
    ON rooms(venue_id);

CREATE INDEX idx_reservation_user
    ON reservations(user_id);

CREATE INDEX idx_reservation_venue
    ON reservations(venue_id);

CREATE INDEX idx_reservation_table
    ON reservations(table_id);

CREATE INDEX idx_reservation_room
    ON reservations(room_id);
CREATE INDEX idx_reservation_start_time
    ON reservations(start_time);

CREATE INDEX idx_reservation_status
    ON reservations(status);

CREATE INDEX idx_payment_reservation
    ON payments(reservation_id);

CREATE INDEX idx_review_venue
    ON reviews(venue_id);

CREATE INDEX idx_review_user
    ON reviews(user_id);

CREATE INDEX idx_favorite_user
    ON favorites(user_id);

CREATE INDEX idx_favorite_venue
    ON favorites(venue_id);

CREATE INDEX idx_notification_user
    ON notifications(user_id);

CREATE INDEX idx_notification_read
    ON notifications(is_read);

CREATE INDEX idx_media_venue
    ON media(venue_id);

CREATE INDEX idx_discount_venue
    ON discounts(venue_id);

CREATE INDEX idx_discount_code
    ON discounts(code);


-- ============================================================
-- RESERVATION DOUBLE-BOOKING PROTECTION
-- ============================================================

CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE reservations
ADD CONSTRAINT no_table_double_booking
EXCLUDE USING gist (
    table_id WITH =,
    tstzrange(start_time, end_time, '[)') WITH &&
)
WHERE (
    table_id IS NOT NULL
    AND status IN ('PENDING', 'CONFIRMED')
);


ALTER TABLE reservations
ADD CONSTRAINT no_room_double_booking
EXCLUDE USING gist (
    room_id WITH =,
    tstzrange(start_time, end_time, '[)') WITH &&
)
WHERE (
    room_id IS NOT NULL
    AND status IN ('PENDING', 'CONFIRMED')
);


-- ============================================================
-- DEFAULT CATEGORIES
-- ============================================================

INSERT INTO categories
(name, slug, description)
VALUES
('Cafe', 'cafe', 'Cafes and coffee shops'),
('Restaurant', 'restaurant', 'Restaurants'),
('Breakfast', 'breakfast', 'Breakfast venues'),
('Birthday', 'birthday', 'Birthday and celebration venues'),
('Mafia', 'mafia', 'Mafia game rooms'),
('Gol Ya Poch', 'gol-ya-poch', 'Gol Ya Poch game rooms'),
('Game Room', 'game-room', 'Group game venues'),
('Romantic', 'romantic', 'Romantic venues'),
('Family', 'family', 'Family friendly venues'),
('VIP', 'vip', 'VIP and private venues')
ON CONFLICT (slug) DO NOTHING;


-- ============================================================
-- DEFAULT FACILITIES
-- ============================================================

INSERT INTO facilities
(name)
VALUES
('WiFi'),
('Parking'),
('Live Music'),
('Projector'),
('Smoking Area'),
('Outdoor Area'),
('Game Room'),
('Private Room'),
('Air Conditioning'),
('VIP Room')
ON CONFLICT (name) DO NOTHING;


-- ============================================================
-- END OF MIZMAN DATABASE
-- ============================================================