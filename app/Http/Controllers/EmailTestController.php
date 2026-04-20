<?php

namespace App\Http\Controllers;

use App\Mail\TestEmail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Inertia\Inertia;

class EmailTestController extends Controller
{
    /**
     * Display the email test form.
     */
    public function index()
    {
        return Inertia::render('EmailTest/Index', [
            'fromAddress' => config('mail.from.address'),
        ]);
    }

    /**
     * Send a test email.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'to' => ['required', 'email'],
            'cc' => ['nullable', 'email'],
            'subject' => ['required', 'string', 'max:255'],
            'body' => ['required', 'string'],
        ]);

        $mail = Mail::to($validated['to']);

        if (! empty($validated['cc'])) {
            $mail->cc($validated['cc']);
        }

        $mail->send(new TestEmail(
            subject: $validated['subject'],
            body: $validated['body']
        ));

        return redirect()->route('email-test')->with('success', 'Test email sent successfully.');
    }
}
