<template>
  <AppLayout>
    <div class="d-flex justify-space-between align-center mb-4">
      <h1>Roles</h1>
      <v-btn color="primary" prepend-icon="mdi-plus" href="/roles/create">
        Add Role
      </v-btn>
    </div>

    <v-card>
      <v-table>
        <thead>
          <tr>
            <th class="text-left">Name</th>
            <th class="text-left">Users</th>
            <th class="text-left">Created</th>
            <th class="text-left">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="role in roles.data" :key="role.id">
            <td>{{ role.name }}</td>
            <td>{{ role.users_count }}</td>
            <td>{{ role.created_at }}</td>
            <td>
              <v-btn
                size="small"
                variant="text"
                icon="mdi-pencil"
                :href="`/roles/${role.id}/edit`"
              />
              <v-btn
                size="small"
                variant="text"
                icon="mdi-delete"
                color="error"
                :disabled="role.users_count > 0"
                @click="deleteRole(role.id)"
              />
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-card>

    <div v-if="roles.links" class="mt-4">
      <v-pagination
        v-model="currentPage"
        :length="roles.last_page"
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
  roles: Object,
});

const currentPage = ref(props.roles?.current_page || 1);

const changePage = (pageNumber) => {
  router.get(`/roles?page=${pageNumber}`);
};

const deleteRole = (roleId) => {
  if (confirm('Are you sure you want to delete this role?')) {
    router.delete(`/roles/${roleId}`);
  }
};
</script>
