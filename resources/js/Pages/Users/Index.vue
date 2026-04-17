<template>
  <AppLayout>
    <div class="d-flex justify-space-between align-center mb-4">
      <h1>Users</h1>
      <v-btn color="primary" prepend-icon="mdi-plus" href="/users/create">
        Add User
      </v-btn>
    </div>

    <v-card>
      <v-table>
        <thead>
          <tr>
            <th class="text-left">Name</th>
            <th class="text-left">Email</th>
            <th class="text-left">Solis ID</th>
            <th class="text-left">Role</th>
            <th class="text-left">Created</th>
            <th class="text-left">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users.data" :key="user.id">
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.solis_id }}</td>
            <td>{{ user.role_name }}</td>
            <td>{{ user.created_at }}</td>
            <td>
              <v-btn
                size="small"
                variant="text"
                icon="mdi-pencil"
                :href="`/users/${user.id}/edit`"
              />
              <v-btn
                size="small"
                variant="text"
                icon="mdi-delete"
                color="error"
                @click="deleteUser(user.id)"
              />
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-card>

    <div v-if="users.links" class="mt-4">
      <v-pagination
        v-model="currentPage"
        :length="users.last_page"
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
  users: Object,
});

const currentPage = ref(props.users?.current_page || 1);

const changePage = (pageNumber) => {
  router.get(`/users?page=${pageNumber}`);
};

const deleteUser = (userId) => {
  if (confirm('Are you sure you want to delete this user?')) {
    router.delete(`/users/${userId}`);
  }
};
</script>
