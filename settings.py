"""Application settings and configuration.

This module handles all configuration for the Gmail bot assistant,
using pydantic-settings for environment-based configuration.
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    # Gmail API configuration
    gmail_credentials_path: str = "credentials.json"
    gmail_token_path: str = "token.json"

    # Ollama configuration
    ollama_host: str = "http://localhost:11434"
    ollama_model: str = "nomic-embed-text"

    # Storage configuration
    storage_dir: str = ".gmail-bot-data"

    # Logging configuration
    log_level: str = "INFO"
    log_format: str = "json"

    # Classification settings
    classification_threshold: float = 0.7
    max_emails_per_run: int = 100

    # Feature flags
    enable_embedding_classification: bool = True
    enable_rule_engine: bool = True
    dry_run: bool = False
    debug: bool = False


def get_settings() -> Settings:
    """Get application settings singleton."""
    return Settings()
