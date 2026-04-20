<template>
  <AppLayout>
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <div>
          <v-icon icon="mdi-heart-pulse" color="error" class="mr-2" />
          <strong>Heartbeat entries</strong>
          <span class="text-medium-emphasis text-body-2 ml-2">
            — new record added every minute by the scheduler
          </span>
        </div>
        <div class="d-flex align-center ga-2">
          <v-chip color="secondary" size="small">
            {{ entries.total }} total
          </v-chip>
          <v-btn
            color="error"
            size="small"
            prepend-icon="mdi-heart-pulse"
            :loading="addingRecord"
            @click="addRecord"
          >
            Add record
          </v-btn>
        </div>
      </v-card-title>

      <v-divider />

      <v-card-text v-if="entries.data.length === 0" class="text-medium-emphasis font-italic">
        No entries yet. Run <code>php artisan heartbeat:add</code> manually or wait for the scheduler.
      </v-card-text>

      <v-table v-else density="compact" hover>
        <thead>
          <tr>
            <th style="width: 1%">#</th>
            <th style="width: 20%">Recorded at</th>
            <th>Message</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="entry in entries.data" :key="entry.id">
            <td class="text-medium-emphasis text-body-2">{{ entry.id }}</td>
            <td class="text-no-wrap text-body-2">{{ entry.recorded_at }}</td>
            <td class="font-mono text-body-2">{{ entry.message }}</td>
          </tr>
        </tbody>
      </v-table>

      <v-divider v-if="entries.last_page > 1" />

      <v-card-actions v-if="entries.last_page > 1" class="justify-center">
        <v-pagination
          v-model="currentPage"
          :length="entries.last_page"
          @update:model-value="changePage"
        />
      </v-card-actions>
    </v-card>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { router } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
  entries: Object,
});

const currentPage = ref(props.entries?.current_page || 1);
const addingRecord = ref(false);

const changePage = (pageNumber) => {
  router.get(`/db-heartbeat?page=${pageNumber}`);
};

const addRecord = () => {
  addingRecord.value = true;
  router.post('/db-heartbeat', {}, {
    onFinish: () => {
      addingRecord.value = false;
    },
  });
};
</script>

<style scoped>
.font-mono {
  font-family: monospace;
}
</style>
