<template>
  <AppLayout>
    <div class="d-flex justify-space-between align-center mb-4">
      <h1>Migrations</h1>
    </div>

    <v-card>
      <v-table>
        <thead>
          <tr>
            <th class="text-left">ID</th>
            <th class="text-left">Migration</th>
            <th class="text-left">Batch</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="migration in migrations.data" :key="migration.id">
            <td>{{ migration.id }}</td>
            <td>{{ migration.migration }}</td>
            <td>{{ migration.batch }}</td>
          </tr>
        </tbody>
      </v-table>
    </v-card>

    <div v-if="migrations.links" class="mt-4">
      <v-pagination
        v-model="currentPage"
        :length="migrations.last_page"
        @update:model-value="changePage"
      />
    </div>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { router } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
  migrations: Object,
});

const currentPage = ref(props.migrations?.current_page || 1);

const changePage = (pageNumber) => {
  router.get(`/migrations?page=${pageNumber}`);
};
</script>
