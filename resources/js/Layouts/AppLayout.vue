<template>
  <v-app>
    <v-app-bar color="primary" flat>
      <template v-if="user?.id" v-slot:prepend>
        <v-app-bar-nav-icon @click.stop="drawer = !drawer" color="black" />
      </template>
      
      <img 
        src="/images/hts-appteam-base/uu-logo-en.svg" 
        alt="University Logo"
        class="navbar-logo"
        style="height: 100px; cursor: pointer;"
        @click="navigateTo('/')"
      />
      
      <v-spacer />
      
      <span class="app-title">{{ appName }}</span>
      
      <v-spacer />
      
      <template v-if="user?.id">
        <v-menu>
          <template v-slot:activator="{ props }">
            <v-btn v-bind="props" variant="text" color="black">
              {{ user.name }}
              <v-icon icon="mdi-chevron-down" />
            </v-btn>
          </template>
          <v-list>
            <v-list-item @click="logout">
              <v-list-item-title>Logout</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </template>
      <template v-else>
        <v-btn variant="flat" color="secondary" href="/auth/oidc/login">
          <v-icon icon="mdi-login" class="mr-1" />
          Login
        </v-btn>
      </template>
    </v-app-bar>

    <v-navigation-drawer 
      v-if="user?.id" 
      v-model="drawer" 
      temporary
      location="left"
    >
      <v-list nav>
        <v-list-item
          v-for="item in visibleMenuItems"
          :key="item.to"
          :href="item.to"
          :title="item.title"
          :prepend-icon="item.icon"
          @click="drawer = false"
          color="primary"
        />
      </v-list>
    </v-navigation-drawer>

    <v-main>
      <v-container class="py-8">
        <v-alert
          v-if="$page.props.flash?.success"
          type="success"
          closable
          class="mb-4"
          variant="tonal"
          border="start"
        >
          {{ $page.props.flash.success }}
        </v-alert>
        <v-alert
          v-if="$page.props.flash?.error"
          type="error"
          closable
          class="mb-4"
          variant="tonal"
          border="start"
        >
          {{ $page.props.flash.error }}
        </v-alert>
        <slot />
      </v-container>
    </v-main>

    <v-footer app class="text-center d-flex flex-column">
      <div class="text-caption text-medium-emphasis">
        Frontend v{{ versions.frontend }} | Backend v{{ versions.backend }}
      </div>
    </v-footer>
  </v-app>
</template>

<script setup>
import { usePage } from '@inertiajs/vue3';
import { computed, ref } from 'vue';

const page = usePage();
const drawer = ref(false);

const appName = computed(() => page.props.appName || 'FSW-Openshift');
const user = computed(() => page.props.auth?.user);
const versions = computed(() => page.props.versions || { frontend: 'unknown', backend: 'unknown' });

const menuItems = [
  {
    title: 'Home',
    to: '/',
    icon: 'mdi-home',
    adminOnly: true,
  },
  {
    title: 'DB Heartbeat',
    to: '/db-heartbeat',
    icon: 'mdi-heart-pulse',
    adminOnly: true,
  },
  {
    title: 'File Heartbeat',
    to: '/file-heartbeat',
    icon: 'mdi-file-document',
    adminOnly: true,
  },
  {
    title: 'Migrations',
    to: '/migrations',
    icon: 'mdi-database-sync',
    adminOnly: true,
  },
  {
    title: 'Chat',
    to: '/chat',
    icon: 'mdi-chat',
    adminOnly: true,
  },
  {
    title: 'Email Test',
    to: '/email-test',
    icon: 'mdi-email-outline',
    adminOnly: true,
  },
  {
    title: 'Users',
    to: '/users',
    icon: 'mdi-account-multiple',
    adminOnly: true,
  },
  {
    title: 'Roles',
    to: '/roles',
    icon: 'mdi-shield-account',
    adminOnly: true,
  },
];

const visibleMenuItems = computed(() => 
  menuItems.filter(item => !item.adminOnly || user.value.isAdmin)
);

const navigateTo = (path) => {
  window.location.href = path;
};

const logout = () => {
  window.location.href = '/logout';
};
</script>

<style scoped>
.app-title {
  font-family: 'Merriweather', Georgia, serif;
  font-weight: 700;
  font-size: 1.25rem;
  color: #262626;
}
</style>

