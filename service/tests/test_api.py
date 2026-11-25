from fastapi.testclient import TestClient
from tests.test_models import valid_card_data

from main import app, cards
from models import CardIn
import pytest

client = TestClient(app)

@pytest.fixture(autouse=True)
def reset_box_score():
    cards.clear()   # runs before each test

def test_post_card_returns_the_card():
    # 1. Import valid_card_data from tests.test_models (or copy it here)
    r = client.post("/cards", json=valid_card_data())
    assert r.status_code == 200
    assert r.json() == valid_card_data()


def test_get_cards_returns_posted_cards():
    # Post one card, then GET /cards
    r = client.post("/cards", json=valid_card_data())
    
    res = client.get("/cards")
    # Expect 200 and a list containing exactly that card
    assert res.status_code == 200
    assert res.json() == [valid_card_data()]