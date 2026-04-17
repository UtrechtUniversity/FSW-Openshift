<template>
  <AppLayout>
    <div class="mb-6">
      <v-btn
        variant="text"
        prepend-icon="mdi-arrow-left"
        href="/users"
      >
        Back to Users
      </v-btn>
      <h1 class="mt-4">Create User</h1>
    </div>

    <v-card class="mx-auto" max-width="500">
      <v-card-text>
        <v-form @submit.prevent="submit">
          <v-text-field
            v-model="form.solis_id"
            label="Solis ID"
            :error-messages="form.errors.solis_id"
            required
            class="mb-4"
          />

          <v-select
            v-model="form.role_id"
            :items="roles"
            item-title="name"
            item-value="id"
            label="Role"
            :error-messages="form.errors.role_id"
            required
            class="mb-4"
          />

          <v-btn
            type="submit"
            color="primary"
            class="mt-4"
            :loading="form.processing"
          >
            Create User
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
  roles: Array,
});

const form = useForm({
  solis_id: '',
  role_id: null,
});

const submit = () => {
  form.post('/users');
};
</script>
