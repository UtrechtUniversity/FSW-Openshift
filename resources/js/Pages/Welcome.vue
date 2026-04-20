<template>
  <AppLayout>
    <v-card class="mx-auto" max-width="800">
      <v-card-title class="text-h5">
        <v-icon icon="mdi-view-dashboard" class="mr-2" />
        Dashboard
      </v-card-title>
      
      <v-card-text>
        <v-alert v-if="status" type="success" class="mb-4" closable>
          {{ status }}
        </v-alert>
        
        <p class="text-body-1 mb-4">
          Nieuwe handige dingen Nieuwe versie 14 april 2026.
        </p>
        
        <template v-if="auth?.user">
          <v-alert type="info" variant="tonal" class="mb-4">
            <div class="d-flex align-center">
              <v-icon icon="mdi-account-check" class="mr-2" />
              <span>{{ auth.user.name }} - You are logged in!</span>
            </div>
            <div class="mt-2">
              Je hebt de rol: <strong>{{ auth.user.role_name }}</strong>
            </div>
            <div class="m-2">Add version during build</div>
            <div class="m-2">Add websockets</div>
            <div class="m-2">Add test email</div>
            <div class="m-2"></div>
            <div class="m-2"></div>
          </v-alert>
        </template>
        <template v-else>
          <v-alert type="warning" variant="tonal">
            <v-icon icon="mdi-account-off" class="mr-2" />
            You are not logged in!
          </v-alert>
        </template>
      </v-card-text>
    </v-card>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { usePage } from '@inertiajs/vue3';
import { computed } from 'vue';

const page = usePage();
const auth = computed(() => page.props.auth);
const status = computed(() => page.props.flash?.status);
</script>
