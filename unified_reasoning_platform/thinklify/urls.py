from django.urls import path
from . import views

urlpatterns = [
    path('', views.thinklify_home, name='thinklify_home'),
    path('reasoning-game/', views.reasoning_game, name='reasoning_game'),
]