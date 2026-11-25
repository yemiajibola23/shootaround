from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_post_card_returns_the_card():
    # 1. Import valid_card_data from tests.test_models (or copy it here)
    from tests.test_models import valid_card_data
    r = client.post("/cards", json=valid_card_data())
    assert r.status_code == 200
    assert r.json() == valid_card_data()
