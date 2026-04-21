<?php

namespace App\Providers;

use App\Http\Controllers\OIDC\LoginController as DebugLoginController;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use UU\HTSAppTeam\LaravelBase\Http\Controllers\OIDC\LoginController as VendorLoginController;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Bind the vendor OIDC LoginController to our debug subclass so that
        // DebugOpenIDConnectClient is used, which logs the raw token endpoint
        // response. Remove this binding (and the two debug classes) once the
        // OIDC issue is resolved.
        $this->app->bind(VendorLoginController::class, DebugLoginController::class);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot()
    {
        if (config('hts-appteam.force_https')) {
            URL::forceScheme('https');
        }
    }
}
