<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'FSW-Openshift') }}</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet"/>

    <!-- Include Plausible.IO script for privacy friendly stats -->
    <script defer data-domain="<?= parse_url(env('APP_URL'), PHP_URL_HOST) ?>" src="https://plausible.io/js/plausible.js"></script>

    @inertiaHead
</head>
<body>
    @inertia

    <!-- Vite Scripts -->
    @vite(['resources/js/app.js'])
</body>
</html>
