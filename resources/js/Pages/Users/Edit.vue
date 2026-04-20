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
      <h1 class="mt-4">Edit User</h1>
    </div>

    <v-card class="mx-auto" max-width="500">
      <v-card-text>
        <v-form @submit.prevent="submit">
          <v-text-field
            v-model="form.name"
            label="Name"
            disabled
            class="mb-4"
          />

          <v-text-field
            v-model="form.email"
            label="Email"
            type="email"
            disabled
            class="mb-4"
          />

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
            Update User
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
  user: Object,
  roles: Array,
});

const form = useForm({
  name: props.user.name,
  email: props.user.email,
  solis_id: props.user.solis_id || '',
  role_id: props.user.role_id,
});

const submit = () => {
  form.put(`/users/${props.user.id}`);
};
</script>
