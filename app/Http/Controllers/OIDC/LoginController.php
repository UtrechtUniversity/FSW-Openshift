<?php

namespace App\Http\Controllers\OIDC;

use App\Services\DebugOpenIDConnectClient;
use Exception;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Http\RedirectResponse;
use Illuminate\Routing\Redirector;
use Illuminate\Support\Facades\Auth;
use Jumbojett\OpenIDConnectClient;
use Jumbojett\OpenIDConnectClientException;
use UU\HTSAppTeam\LaravelBase\Http\Controllers\OIDC\OIDCController;
use UU\HTSAppTeam\LaravelBase\Http\Controllers\OIDC\OIDCFunctions;

/**
 * Overrides the vendor LoginController to inject DebugOpenIDConnectClient,
 * which logs raw HTTP responses from the token endpoint.
 *
 * Remove this class (and app/Services/DebugOpenIDConnectClient.php and
 * the binding in AppServiceProvider) once the OIDC issue is resolved.
 */
class LoginController extends OIDCController
{
    use OIDCFunctions;

    /**
     * Override getOIDCClient() to use DebugOpenIDConnectClient instead of
     * the base OpenIDConnectClient. This lets us log the raw token endpoint
     * response to diagnose the null json_decode() issue.
     *
     * @return OpenIDConnectClient
     */
    private function getOIDCClient(): OpenIDConnectClient
    {
        $oidc = new DebugOpenIDConnectClient(
            config('hts-appteam.oidc_settings.provider_url'),
            config('hts-appteam.oidc_settings.client_id'),
            config('hts-appteam.oidc_settings.client_secret')
        );

        $oidc->addScope(config('hts-appteam.oidc_settings.scopes'));

        if (config('hts-appteam.oidc_settings.2fa_enabled')) {
            $oidc->addAuthParam(['acr_values' => 'urn:uu.nl:idp:contract:password:multifactor']);
        }

        $oidc->setRedirectURL(route('auth.oidc.login.callback'));

        return $oidc;
    }

    /**
     * @throws OpenIDConnectClientException
     */
    public function index()
    {
        $oidc = $this->getOIDCClient();
        $oidc->authenticate();
    }

    /**
     * @throws OpenIDConnectClientException
     * @throws Exception
     */
    public function callback()
    {
        $oidc = $this->getOIDCClient();

        $oidc->authenticate();

        session(['loginType' => 'OIDC']);
        session(['oidcAccessToken' => $oidc->getAccessToken()]);
        session(['oidcRefreshToken' => $oidc->getRefreshToken()]);
        session(['oidcIDToken' => $oidc->getIdToken()]);

        $oidcUser = (array) $oidc->requestUserInfo();

        $attributes = $this->retrieveRequestedAttributes($oidcUser);

        $currentUser = $this->getUser($oidcUser[$this->getUserIdentifier()]);

        if (is_null($currentUser) && !$this->canUserRegister($attributes)) {
            if (config('hts-appteam.oidc_settings.allow_anonymous')) {
                if (!self::checkFilter($attributes, 'hts-appteam.oidc_settings.allow_anonymous_filter')) {
                    $this->log('User authenticated, but not allowed for anonymous entry.');
                    return $this->logoutOIDC();
                }

                session($this->getAttributeAnonymousUser($oidcUser));

                if (config('hts-appteam.allow_deeplink')) {
                    if (session('requested_url')) {
                        return redirect(session('requested_url'));
                    }
                }

                if (config()->has('hts-appteam.redirect_after_login')) {
                    return redirect()->route(config('hts-appteam.redirect_after_login'));
                }

                return redirect('/');
            }

            $this->log('User authenticated, but not allowed to register');
            return $this->logoutOIDC();
        }

        if (is_null($currentUser) || !$this->areAttributesAvailable($currentUser)) {
            return redirect()->route('auth.oidc.permissions');
        }

        $this->log("User '{$currentUser->solis_id}' logging in, using OIDC");

        Auth::login($currentUser);

        $this->updateFieldsFromOIDC($currentUser, $attributes['application']);

        if (config('hts-appteam.allow_deeplink')) {
            if (session('requested_url')) {
                return redirect(session('requested_url'));
            }
        }

        if (config()->has('hts-appteam.redirect_after_login')) {
            return redirect()->route(config('hts-appteam.redirect_after_login'));
        }

        return redirect('/');
    }

    /**
     * @return Application|RedirectResponse|Redirector
     */
    public function logoutCallback()
    {
        $route = 'auth.logged_out';
        if (Auth::guest() && !config('hts-appteam.oidc_settings.allow_anonymous')) {
            $route = 'auth.no_registration_allowed';
        }

        Auth::logout();
        return redirect(route($route));
    }
}
