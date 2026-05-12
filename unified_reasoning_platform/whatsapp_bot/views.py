from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def whatsapp_webhook(request):

    if request.method == "GET":
        return JsonResponse({
            "message": "Webhook Verification Success"
        })

    elif request.method == "POST":
        return JsonResponse({
            "message": "Incoming WhatsApp Data Received"
        })

    return JsonResponse({
        "error": "Invalid Request"
    }, status=400)