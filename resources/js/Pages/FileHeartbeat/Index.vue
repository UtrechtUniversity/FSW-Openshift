<template>
  <AppLayout>
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <div>
          <v-icon icon="mdi-folder-open" color="warning" class="mr-2" />
          <strong>File heartbeat</strong>
          <span class="text-medium-emphasis text-body-2 ml-2">
            — <code>storage/app/files/</code>
          </span>
        </div>
        <div class="d-flex align-center ga-2">
          <v-chip color="secondary" size="small">
            {{ files.length }} files
          </v-chip>
          <v-btn
            color="primary"
            size="small"
            prepend-icon="mdi-file-plus"
            :loading="addingFile"
            @click="addFile"
          >
            Add file
          </v-btn>
        </div>
      </v-card-title>

      <v-divider />

      <v-card-text v-if="files.length === 0" class="text-medium-emphasis font-italic">
        No files yet. Click <strong>Add file</strong> or wait for the scheduler to run
        <code>php artisan heartbeat:add-file</code>.
      </v-card-text>

      <v-table v-else density="compact" hover>
        <thead>
          <tr>
            <th style="width: 1%">#</th>
            <th>Filename</th>
            <th>Content</th>
            <th style="width: 1%" class="text-right">Size</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(file, index) in files" :key="file.name">
            <td class="text-medium-emphasis text-body-2">{{ index + 1 }}</td>
            <td class="font-mono text-body-2 text-no-wrap">{{ file.name }}</td>
            <td class="font-mono text-body-2">{{ file.content }}</td>
            <td class="text-right text-medium-emphasis text-body-2 text-no-wrap">{{ file.size }} B</td>
          </tr>
        </tbody>
      </v-table>
    </v-card>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { router } from '@inertiajs/vue3';
import { ref } from 'vue';

defineProps({
  files: {
    type: Array,
    default: () => [],
  },
});

const addingFile = ref(false);

const addFile = () => {
  addingFile.value = true;
  router.post('/file-heartbeat', {}, {
    onFinish: () => {
      addingFile.value = false;
    },
  });
};
</script>

<style scoped>
.font-mono {
  font-family: monospace;
}
</style>
