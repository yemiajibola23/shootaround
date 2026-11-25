from fastapi import FastAPI

from models import CardIn

app = FastAPI()


@app.post("/cards")
def create_card(card: CardIn) -> CardIn:
    return card