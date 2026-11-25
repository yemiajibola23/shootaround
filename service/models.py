from pydantic import BaseModel
from enum import StrEnum

class CardKind(StrEnum):
    code = "code"
    explain = "explain"
    recall = "recall"

class CardIn(BaseModel):
    deck: str
    concept: str
    kind: CardKind
    prompt: str
    answer: str
    source:str = "manual"
