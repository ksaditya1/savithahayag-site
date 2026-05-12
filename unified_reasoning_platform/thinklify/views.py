from django.shortcuts import render

def thinklify_home(request):
    return render(request, "thinklify/index.html")

def reasoning_game(request):
    return render(request, "thinklify/reasoning_game.html")