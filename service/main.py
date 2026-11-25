from fastapi import FastAPI
from models import CardIn

app = FastAPI()
cards: list[CardIn] = []

@app.post("/cards")
def create_card(card: CardIn) -> CardIn:
    cards.append(card)
    return card

# Storage: a module-level list of CardIn, shared by both routes
# create_card: also append the card to the list
# GET /cards: return every stored card
@app.get("/cards")
def list_cards() -> list[CardIn]:
    return cards

