$ErrorActionPreference = "Stop"

Write-Host "=== SAVITHA HAYAG CORE AI WEBSITE UPGRADE STARTING ===" -ForegroundColor Cyan

$root = Get-Location
$backup = Join-Path $root "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

Write-Host "Creating backup..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $backup -Force | Out-Null

if (Test-Path ".\templates") {
    Copy-Item ".\templates" $backup -Recurse -Force
}

if (Test-Path ".\static") {
    Copy-Item ".\static" $backup -Recurse -Force
}

Copy-Item ".\backend" $backup -Recurse -Force

Write-Host "Backup complete." -ForegroundColor Green

Write-Host "Creating clean frontend structure..." -ForegroundColor Yellow

$folders = @(
    ".\templates",
    ".\templates\partials",
    ".\templates\thinklify",
    ".\templates\pilots",
    ".\static",
    ".\static\css",
    ".\static\js",
    ".\static\images",
    ".\static\thinklify",
    ".\static\thinklify\css",
    ".\static\thinklify\js"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

Write-Host "Creating base template..." -ForegroundColor Yellow

@'
{% load static %}
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{% block title %}Savitha Hayag Core AI{% endblock %}</title>
<link rel="stylesheet" href="{% static 'css/main.css' %}">
</head>
<body>

{% include 'partials/navbar.html' %}

{% block content %}{% endblock %}

{% include 'partials/footer.html' %}

</body>
</html>
'@ | Set-Content ".\templates\base.html"

Write-Host "Creating navbar..." -ForegroundColor Yellow

@'
<header class="navbar">
    <div class="brand">
        <img src="{% static 'images/logo.png' %}" alt="Savitha Hayag">
        <div>
            <div class="brand-name">SAVITHA HAYAG</div>
            <div class="brand-sub">CORE AI</div>
        </div>
    </div>

    <nav>
        <a href="/">Business</a>
        <a href="/thinklify/">Thinklify</a>
        <a href="/active-pilots/">Active Pilots</a>
        <a href="#technology">Technology</a>
        <a href="#contact">Contact</a>
    </nav>
</header>
'@ | Set-Content ".\templates\partials\navbar.html"

Write-Host "Creating footer..." -ForegroundColor Yellow

@'
<footer>
    <p>© 2026 Savitha Hayag Core AI</p>
    <p>Reasoning systems for intelligent futures</p>
</footer>
'@ | Set-Content ".\templates\partials\footer.html"

Write-Host "Creating homepage..." -ForegroundColor Yellow

@'
{% extends "base.html" %}

{% block content %}
<section class="hero">
    <h1>Reasoning Intelligence for Real-World Decisions</h1>
    <p>
        Building an ecosystem of reasoning products through Thinklify,
        cognitive learning systems, and structured AI decision intelligence.
    </p>

    <div class="cta">
        <a href="/thinklify/" class="btn primary">Explore Thinklify</a>
        <a href="/active-pilots/" class="btn secondary">Active Pilots</a>
    </div>
</section>

<section>
    <h2>Business Intelligence</h2>
    <div class="card">AI reasoning for structured decisions and scalable intelligence.</div>
</section>

<section>
    <h2>Thinklify Ecosystem</h2>
    <div class="card">Interactive reasoning products, cognitive learning, deduction systems, and future concept intelligence.</div>
</section>

<section>
    <h2>Active Pilot Programs</h2>
    <div class="card">
        Governance participation pilots, WhatsApp-assisted workflows, and structured onboarding for experimental reasoning programs.
    </div>
</section>

<section id="technology">
    <h2>Technology Architecture</h2>
    <div class="card">
        Local-first reasoning engines, edge intelligence, secure structured workflows, and backend governance orchestration.
    </div>
</section>

<section id="contact">
    <h2>Contact</h2>
    <div class="card">
        founder@savithahayag.in
    </div>
</section>
{% endblock %}
'@ | Set-Content ".\templates\home.html"

Write-Host "Creating Thinklify page..." -ForegroundColor Yellow

@'
{% extends "base.html" %}

{% block title %}Thinklify{% endblock %}

{% block content %}
<section class="hero">
    <h1>THINKLIFY</h1>
    <p>
        Learning to think through structured reasoning systems.
    </p>

    <div class="cta">
        <a href="/thinklify/reasoning/" class="btn primary">Try Reasoning Demo</a>
    </div>
</section>
{% endblock %}
'@ | Set-Content ".\templates\thinklify\index.html"

Write-Host "Creating Active Pilots page..." -ForegroundColor Yellow

@'
{% extends "base.html" %}

{% block title %}Active Pilots{% endblock %}

{% block content %}
<section class="hero">
    <h1>Active Pilot Programs</h1>
    <p>
        Experimental participation programs for governance reasoning,
        civic workflows, and AI-assisted structured decision systems.
    </p>
</section>
{% endblock %}
'@ | Set-Content ".\templates\pilots\index.html"

Write-Host "Creating CSS..." -ForegroundColor Yellow

@'
body {
    margin: 0;
    font-family: Segoe UI, sans-serif;
    background: #0b1f3a;
    color: white;
}

.navbar {
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:20px 40px;
    background:#08172d;
    position:sticky;
    top:0;
}

.brand {
    display:flex;
    align-items:center;
    gap:15px;
}

.brand img {
    height:60px;
}

.brand-name {
    font-weight:700;
    font-size:18px;
}

.brand-sub {
    color:#d9a441;
    font-size:12px;
}

nav a {
    color:white;
    margin-left:20px;
    text-decoration:none;
}

.hero {
    padding:100px 20px;
    text-align:center;
}

.hero h1 {
    font-size:48px;
    color:#d9a441;
}

.hero p {
    max-width:700px;
    margin:auto;
    color:#d0d8e0;
}

.cta {
    margin-top:30px;
}

.btn {
    padding:12px 22px;
    text-decoration:none;
    border-radius:8px;
    margin:10px;
}

.primary {
    background:#d9a441;
    color:black;
}

.secondary {
    background:white;
    color:#08172d;
}

section {
    max-width:1100px;
    margin:auto;
    padding:70px 20px;
}

.card {
    background:#122948;
    padding:20px;
    border-radius:12px;
}

footer {
    text-align:center;
    padding:40px;
    background:#06111f;
}
'@ | Set-Content ".\static\css\main.css"

Write-Host "Branding upgrade complete." -ForegroundColor Green
Write-Host "NEXT: wire backend urls + views + drop logo.png into static/images/" -ForegroundColor Cyan