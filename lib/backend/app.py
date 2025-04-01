from fastapi import FastAPI
from pydantic import BaseModel
# import uvicorn
from chatbot import chatbot

app = FastAPI()

class Message(BaseModel):
    message: str
    category: int

@app.post("/")
async def send_message(message: Message):
    # print(message.message)
    # print(message.category)
    response_text = chatbot(message.message, message.category)
    return {"response": response_text}



# if __name__ == "__main__":
#     uvicorn.run(app, host='0.0.0.0',port=8000)