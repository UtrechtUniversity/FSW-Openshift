<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;
use Jumbojett\OpenIDConnectClient;

/**
 * A debug wrapper around OpenIDConnectClient that logs all HTTP requests
 * and responses. Used to diagnose token endpoint failures.
 *
 * Remove this class (and app/Http/Controllers/OIDC/LoginController.php and
 * the binding in AppServiceProvider) once the OIDC issue is resolved.
 */
class DebugOpenIDConnectClient extends OpenIDConnectClient
{
    /**
     * @param string $url
     * @param string|null $post_body
     * @param array $headers
     * @return string
     */
    protected function fetchURL($url, $post_body = null, $headers = [])
    {
        Log::debug('[OIDC Debug] fetchURL called', [
            'url'      => $url,
            'method'   => $post_body !== null ? 'POST' : 'GET',
            'headers'  => $headers,
            'post_body' => $post_body,
        ]);

        $response = parent::fetchURL($url, $post_body, $headers);

        Log::debug('[OIDC Debug] fetchURL response', [
            'url'           => $url,
            'http_code'     => $this->getResponseCode(),
            'raw_response'  => $response,
            'json_decoded'  => json_decode($response),
            'json_error'    => json_last_error_msg(),
        ]);

        return $response;
    }
}
