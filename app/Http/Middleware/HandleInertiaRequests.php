<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;

class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that is loaded on the first page visit.
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determine the current asset version.
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define the props that are shared by default.
     *
     * @return array<string, mixed>
     */
    public function share(Request $request): array
    {
        // Read frontend version from package.json
        $packageJson = json_decode(file_get_contents(base_path('package.json')), true);
        $frontendVersion = $packageJson['version'] ?? 'unknown';

        // Read backend version from composer.json
        $composerJson = json_decode(file_get_contents(base_path('composer.json')), true);
        $backendVersion = $composerJson['version'] ?? 'unknown';

        return array_merge(parent::share($request), [
            'auth' => [
                'user' => $request->user() ? [
                    'id' => $request->user()->id,
                    'name' => $request->user()->name,
                    'email' => $request->user()->email,
                    'role_name' => $request->user()->role->name ?? null,
                    'isAdmin' => $request->user()->isAdmin(),
                ] : null,
            ],
            'flash' => [
                'success' => fn () => $request->session()->get('success'),
                'error' => fn () => $request->session()->get('error'),
                'status' => fn () => $request->session()->get('status'),
            ],
            'appName' => config('app.name', 'FSW-Openshift'),
            'versions' => [
                'frontend' => $frontendVersion,
                'backend' => $backendVersion,
            ],
        ]);
    }
}
