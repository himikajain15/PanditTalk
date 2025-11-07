import json
from channels.generic.websocket import AsyncWebsocketConsumer
from .models import ChatThread, ChatMessage
from asgiref.sync import sync_to_async

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.thread_id = self.scope['url_route']['kwargs']['thread_id']
        self.room_group_name = f'chat_{self.thread_id}'
        await self.channel_layer.group_add(self.room_group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def receive(self, text_data):
        data = json.loads(text_data)
        message, sender_id = data['message'], data['sender_id']

        await self.save_message(self.thread_id, sender_id, message)
        await self.channel_layer.group_send(
            self.room_group_name,
            {'type': 'chat_message', 'message': message, 'sender_id': sender_id}
        )

    async def chat_message(self, event):
        await self.send(text_data=json.dumps(event))

    @sync_to_async
    def save_message(self, thread_id, sender_id, message):
        thread = ChatThread.objects.get(id=thread_id)
        sender = thread.user.__class__.objects.get(id=sender_id)
        ChatMessage.objects.create(thread=thread, sender=sender, message=message)
