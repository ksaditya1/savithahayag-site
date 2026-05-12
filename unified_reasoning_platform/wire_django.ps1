$ErrorActionPreference = "Stop"

Write-Host "=== DJANGO ROUTING WIRING STARTING ===" -ForegroundColor Cyan

# backend/settings.py update
$settings = ".\backend\settings.py"

if (Test-Path $settings) {
    $content = Get-Content $settings -Raw

    if ($content -notmatch "STATICFILES_DIRS") {
        $content += @"

STATIC_URL = '/static/'
STATICFILES_DIRS = [BASE_DIR / 'static']
"@
    }

    if ($content -notmatch "BASE_DIR / 'templates'") {
        $content = $content -replace "('DIRS': \[)(.*?)(\])", "'DIRS': [BASE_DIR / 'templates']"
    }

    Set-Content $settings $content
    Write-Host "settings.py updated" -ForegroundColor Green
}

# thinklify urls
@'
from django.urls import path
from . import views

urlpatterns = [
    path('', views.thinklify_home, name='thinklify-home'),
]
'@ | Set-Content ".\thinklify\urls.py"

# thinklify views
@'
from django.shortcuts import render

def thinklify_home(request):
    return render(request, "thinklify/index.html")
'@ | Set-Content ".\thinklify\views.py"

# governance urls
@'
from django.urls import path
from . import views

urlpatterns = [
    path('', views.governance_home, name='governance-home'),
]
'@ | Set-Content ".\governance\urls.py"

# governance views
@'
from django.shortcuts import render

def governance_home(request):
    return render(request, "pilots/index.html")
'@ | Set-Content ".\governance\views.py"

# root homepage view helper
@'
from django.shortcuts import render

def home(request):
    return render(request, "home.html")
'@ | Set-Content ".\backend\site_views.py"

# backend urls
@'
from django.contrib import admin
from django.urls import path, include
from .site_views import home

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home),
    path('thinklify/', include('thinklify.urls')),
    path('active-pilots/', include('governance.urls')),
]
'@ | Set-Content ".\backend\urls.py"

Write-Host "Routing wired successfully." -ForegroundColor Green
Write-Host "NOW COPY YOUR LOGO TO static\images\logo.png" -ForegroundColor Yellow
Write-Host "THEN RUN: python manage.py runserver" -ForegroundColor Cyan