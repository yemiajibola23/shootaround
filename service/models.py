from pydantic import BaseModel
from enum import StrEnum

class CardKind(StrEnum):
    code = "code"
    explain = "explain"
    recall = "recall"

class Deck(StrEnum):
    ai_engineering = "AI Engineering"
    ios = "iOS"
    basketball_data = "Basketball Data"
    behavioral = "Behavioral"

class CardSource(StrEnum):
    manual = "manual"
    job_assistant = "job assistant"
    generated = "generated"

class CardIn(BaseModel):
    deck: Deck
    concept: str
    kind: CardKind
    prompt: str
    answer: str
    source: CardSource = CardSource.manual
