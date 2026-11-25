import pytest
from pydantic import ValidationError
from models import CardIn, CardKind, Deck, CardSource

def valid_card_data():
    return {"deck": "AI Engineering", "concept": "Aliasing", "kind": "recall",
 "prompt": "What is aliasing?", "answer": "Two names, one object.",
 "source": "manual"}

def test_card_in_rejects_unknown_kind():
    # 1. Build a dict `data` with every CardIn field; set "kind" to "dunk"
    # Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
    data = { **valid_card_data(), "kind": "dunk" }
    # 2. Inside `with pytest.raises(ValidationError):`, create CardIn(**data)
    with pytest.raises(ValidationError):
        CardIn(**data)


def test_card_in_accepts_valid_kind():
        data = valid_card_data()
        card =  CardIn(**data)
        
        assert card.kind == CardKind.recall
    # 3. Expect card.kind == CardKind.recall (also import CardKind at the top)
        pass  # delete once the steps are in

def test_card_in_parses_deck_and_source():
    # 1. Build a valid `data` dict with "deck": "AI Engineering", "source": "generated"
    data = {**valid_card_data(), "source": "generated"}
    # 2. card = CardIn.model_validate(data)
    card = CardIn.model_validate(data)
    # 3. Assert card.deck == Deck.ai_engineering and card.source == CardSource.generated
    assert card.deck == Deck.ai_engineering
    assert card.source == "generated"


def test_card_in_rejects_unknown_deck():
    # 1. Build a valid `data` dict, but set "deck" to "Swift"
    data = {**valid_card_data(), "deck": "Swift"}
    # 2. Expect ValidationError from CardIn.model_validate(data)
    with pytest.raises(ValidationError):
        CardIn.model_validate(data)
    
