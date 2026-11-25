import pytest
from pydantic import ValidationError

from models import CardIn, CardKind


def test_card_in_rejects_unknown_kind():
    # 1. Build a dict `data` with every CardIn field; set "kind" to "dunk"
    # Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
    data = {"deck": "iOS", "concept": "structured concurrency", "kind": "dunk", "prompt": "What is a task group?", "answer": "A way to run child tasks in parallel", "source": "manual"}
    # 2. Inside `with pytest.raises(ValidationError):`, create CardIn(**data)
    with pytest.raises(ValidationError):
        CardIn(**data)


def test_card_in_accepts_valid_kind():
        data = {"deck": "iOS", "concept": "structured concurrency", "kind": "recall", "prompt": "What is a task group?", "answer": "A way to run child tasks in parallel", "source": "manual"}
        card =  CardIn(**data)
        
        assert card.kind == CardKind.recall
    # 3. Expect card.kind == CardKind.recall (also import CardKind at the top)
        pass  # delete once the steps are in
