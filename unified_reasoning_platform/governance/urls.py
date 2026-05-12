from django.urls import path
from . import views

urlpatterns = [
    path('', views.governance_home, name='governance-home'),
]
