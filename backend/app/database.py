from sqlmodel import SQLModel, create_engine, Session
import os
import tempfile

# Use /tmp for default SQLite path on Azure Functions (read-only root)
# In production, set DATABASE_URL to your Postgres connection string
default_db = f"sqlite:///{tempfile.gettempdir()}/dev.db"
DATABASE_URL = os.getenv('DATABASE_URL', default_db)

engine = create_engine(DATABASE_URL, echo=False)

def init_db():
    try:
        SQLModel.metadata.create_all(engine)
    except Exception as e:
        print(f"DB Init Error: {e}")

def get_session():
    with Session(engine) as session:
        yield session
