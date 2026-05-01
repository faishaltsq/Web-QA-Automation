from typing import Optional
from sqlmodel import Field, SQLModel
from datetime import datetime

class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    email: str
    name: str
    role: str = "viewer"
    hashed_password: str
    created_at: datetime = Field(default_factory=datetime.utcnow)

class Script(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    filename: str
    filepath: str
    tags: Optional[str] = None
    description: Optional[str] = None
    uploaded_by: int
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

class RunHistory(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    script_id: int
    triggered_by: int
    jenkins_build_id: Optional[str] = None
    status: str = "queued"
    browser: Optional[str] = None
    environment: Optional[str] = None
    started_at: Optional[datetime] = None
    finished_at: Optional[datetime] = None
    allure_url: Optional[str] = None

class EnvVariable(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    script_id: int
    key: str
    encrypted_value: str
    updated_at: datetime = Field(default_factory=datetime.utcnow)

class ScheduledJob(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    script_id: int
    cron_expression: str
    enabled: bool = True
    last_run: Optional[datetime] = None
    next_run: Optional[datetime] = None
    created_by: int
