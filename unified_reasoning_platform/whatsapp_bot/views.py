from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
import json

from .services import send_whatsapp_message


@csrf_exempt
def whatsapp_webhook(request):

    # META WEBHOOK VERIFICATION
    if request.method == "GET":
        verify_token = request.GET.get("hub.verify_token")
        challenge = request.GET.get("hub.challenge")
        mode = request.GET.get("hub.mode")

        if mode == "subscribe" and verify_token == settings.VERIFY_TOKEN:
            return HttpResponse(challenge)

        return JsonResponse({"error": "Invalid verify token"}, status=403)

    # INCOMING WHATSAPP MESSAGES
    elif request.method == "POST":
        try:
            body = json.loads(request.body)

            entry = body.get("entry", [])
            if entry:
                changes = entry[0].get("changes", [])
                if changes:
                    value = changes[0].get("value", {})
                    messages = value.get("messages", [])

                    if messages:
                        sender = messages[0]["from"]

                        send_whatsapp_message(
                            sender,
                            "Savithahayag Governance Pilot connected successfully."
                        )

            return JsonResponse({"status": "ok"})

        except Exception as e:
            return JsonResponse({"error": str(e)}, status=500)

    return JsonResponse({"error": "Method not allowed"}, status=405)