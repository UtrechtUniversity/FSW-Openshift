<template>
  <AppLayout>
    <div class="mb-6">
      <h1>Email Test</h1>
      <p class="text-medium-emphasis">Send a test email to verify email configuration.</p>
    </div>

    <v-card class="mx-auto" max-width="600">
      <v-card-text>
        <v-form @submit.prevent="submit">
          <v-text-field
            :model-value="fromAddress"
            label="From"
            readonly
            disabled
            class="mb-4"
            hint="Configured in environment settings"
            persistent-hint
          />

          <v-text-field
            v-model="form.to"
            label="To"
            type="email"
            :error-messages="form.errors.to"
            required
            class="mb-4"
            placeholder="recipient@example.com"
          />

          <v-text-field
            v-model="form.cc"
            label="CC"
            type="email"
            :error-messages="form.errors.cc"
            class="mb-4"
            placeholder="cc@example.com (optional)"
          />

          <v-text-field
            v-model="form.subject"
            label="Subject"
            :error-messages="form.errors.subject"
            required
            class="mb-4"
            placeholder="Test Email Subject"
          />

          <v-textarea
            v-model="form.body"
            label="Body"
            :error-messages="form.errors.body"
            required
            rows="6"
            class="mb-4"
            placeholder="Enter your email message here..."
          />

          <v-btn
            type="submit"
            color="primary"
            class="mt-4"
            :loading="form.processing"
            prepend-icon="mdi-email-send"
          >
            Send Test Email
          </v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { useForm } from '@inertiajs/vue3';

const props = defineProps({
  fromAddress: String,
});

const form = useForm({
  to: '',
  cc: '',
  subject: '',
  body: '',
});

const submit = () => {
  form.post('/email-test');
};
</script>
