from django.shortcuts import render

def governance_home(request):
    return render(request, "pilots/index.html")
