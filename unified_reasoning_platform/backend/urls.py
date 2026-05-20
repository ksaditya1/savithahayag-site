from django.contrib import admin
from django.urls import path, include
from backend.site_views import home


urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),
    path('thinklify/', include('thinklify.urls')),
    path('active-pilots/', include('governance.urls')),
    path('webhook/', include('whatsapp_bot.urls')),
     path("active-pilots/technology", home, name="technology"),
]