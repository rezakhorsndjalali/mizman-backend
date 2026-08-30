from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    APP_NAME: str = "MIZMAN"
    DEBUG: bool = True

    DATABASE_URL: str = (
        "postgresql+asyncpg://postgres:postgres@localhost:5432/mizman"
    )

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore"
    )


settings = Settings()