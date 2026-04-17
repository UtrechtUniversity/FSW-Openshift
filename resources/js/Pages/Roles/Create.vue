<template>
  <AppLayout>
    <div class="mb-6">
      <v-btn
        variant="text"
        prepend-icon="mdi-arrow-left"
        href="/roles"
      >
        Back to Roles
      </v-btn>
      <h1 class="mt-4">Create Role</h1>
    </div>

    <v-card class="mx-auto" max-width="500">
      <v-card-text>
        <v-form @submit.prevent="submit">
          <v-text-field
            v-model="form.name"
            label="Name"
            :error-messages="form.errors.name"
            required
            class="mb-4"
          />

          <v-btn
            type="submit"
            color="primary"
            class="mt-4"
            :loading="form.processing"
          >
            Create Role
          </v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { useForm } from '@inertiajs/vue3';

const form = useForm({
  name: '',
});

const submit = () => {
  form.post('/roles');
};
</script>
