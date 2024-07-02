<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>FSW-Dualnets</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet"/>
    {{--<script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script> --}}


    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <style>
        [x-cloak] { display: none !important; }
    </style>
    <!-- Layout JS -->
    <script type="application/javascript" src="{{ asset('js/hts-appteam-base/auth.js') }}"></script>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="{{ asset('/css/hts-appteam-base/auth.css') }}">
    {{--    <meta name="theme-color" content="#7952b3">--}}

    <!-- Include Plausible.IO script for privacy friendly stats -->
    <script defer data-domain="<?= parse_url(env('APP_URL'), PHP_URL_HOST) ?>" src="https://plausible.io/js/plausible.js"></script>

    <!-- Scripts -->
    @vite(['resources/sass/app.scss', 'resources/js/app.js'])

</head>

<body>
    @include('layouts.nav')
    <main class="py-5">
        @yield('content')
    </main>
</body>
</html>
