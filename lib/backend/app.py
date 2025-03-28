from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
import chatbot

app = FastAPI()

class Message(BaseModel):
  	message: str

@app.get("/")
async def send_message(message: Message):
		response_text = chatbot(message.message)
		return {"response": response_text}

if __name__ == "__main__":
		uvicorn.run(app, host='127.0.0.1', port=8888)
