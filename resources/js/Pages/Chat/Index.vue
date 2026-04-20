<template>
  <AppLayout>
    <v-card class="mx-auto" max-width="900">
      <v-card-title class="text-h5 d-flex align-center">
        <v-icon icon="mdi-chat" class="mr-2" />
        Live Chat
        <v-spacer />
        <v-chip 
          :color="connectionStatus === 'connected' ? 'success' : connectionStatus === 'connecting' ? 'warning' : 'error'"
          size="small"
          variant="flat"
        >
          <v-icon :icon="connectionStatus === 'connected' ? 'mdi-wifi' : 'mdi-wifi-off'" size="small" class="mr-1" />
          {{ connectionStatus }}
        </v-chip>
      </v-card-title>

      <v-divider />

      <!-- Online Users -->
      <v-card-text class="py-2">
        <div class="d-flex align-center flex-wrap ga-2">
          <v-chip size="small" variant="outlined" color="primary">
            <v-icon icon="mdi-account-group" size="small" class="mr-1" />
            {{ onlineUsers.length }} online
          </v-chip>
          <v-chip 
            v-for="user in onlineUsers" 
            :key="user.id"
            size="small"
            :color="user.id === currentUser?.id ? 'primary' : 'default'"
            variant="tonal"
          >
            <v-icon icon="mdi-account" size="x-small" class="mr-1" />
            {{ user.name }}
            <span v-if="user.id === currentUser?.id" class="ml-1">(you)</span>
          </v-chip>
        </div>
      </v-card-text>

      <v-divider />

      <!-- Messages Area -->
      <v-card-text class="chat-messages" ref="messagesContainer">
        <div v-if="messages.length === 0" class="text-center text-medium-emphasis py-8">
          <v-icon icon="mdi-chat-outline" size="48" class="mb-2" />
          <p>No messages yet. Start the conversation!</p>
        </div>
        
        <div 
          v-for="(msg, index) in messages" 
          :key="index"
          class="message-wrapper mb-3"
          :class="{ 'own-message': msg.user.id === currentUser?.id }"
        >
          <div class="message-bubble pa-3 rounded-lg">
            <div class="d-flex align-center mb-1">
              <strong class="text-body-2">{{ msg.user.name }}</strong>
              <v-spacer />
              <span class="text-caption text-medium-emphasis">{{ formatTime(msg.timestamp) }}</span>
            </div>
            <p class="text-body-1 mb-0">{{ msg.message }}</p>
          </div>
        </div>
      </v-card-text>

      <v-divider />

      <!-- Message Input -->
      <v-card-actions class="pa-4">
        <v-text-field
          v-model="newMessage"
          label="Type your message..."
          variant="outlined"
          density="comfortable"
          hide-details
          @keyup.enter="sendMessage"
          :disabled="connectionStatus !== 'connected'"
          :loading="sending"
        >
          <template v-slot:append-inner>
            <v-btn
              icon="mdi-send"
              variant="text"
              color="primary"
              :disabled="!newMessage.trim() || connectionStatus !== 'connected'"
              :loading="sending"
              @click="sendMessage"
            />
          </template>
        </v-text-field>
      </v-card-actions>
    </v-card>

    <!-- Connection Error Alert -->
    <v-snackbar v-model="showError" color="error" timeout="5000">
      {{ errorMessage }}
      <template v-slot:actions>
        <v-btn variant="text" @click="showError = false">Close</v-btn>
      </template>
    </v-snackbar>

    <!-- Debug Panel -->
    <v-card class="mx-auto mt-4" max-width="900">
      <v-card-title class="text-h6 d-flex align-center">
        <v-icon icon="mdi-bug" class="mr-2" />
        Debug Info
        <v-spacer />
        <v-btn size="small" variant="text" @click="showDebug = !showDebug">
          {{ showDebug ? 'Hide' : 'Show' }}
        </v-btn>
      </v-card-title>
      
      <v-expand-transition>
        <div v-show="showDebug">
          <v-divider />
          <v-card-text>
            <div class="mb-3">
              <strong>Echo Status:</strong> 
              <v-chip :color="echoAvailable ? 'success' : 'error'" size="small" class="ml-2">
                {{ echoAvailable ? 'Available' : 'Not Available' }}
              </v-chip>
            </div>
            
            <div class="mb-3">
              <strong>Connection Status:</strong> 
              <v-chip :color="connectionStatus === 'connected' ? 'success' : 'error'" size="small" class="ml-2">
                {{ connectionStatus }}
              </v-chip>
            </div>

            <div class="mb-3">
              <strong>Current User:</strong>
              <pre class="text-caption bg-grey-lighten-4 pa-2 rounded mt-1">{{ JSON.stringify(currentUser, null, 2) }}</pre>
            </div>
            
            <div>
              <strong>Debug Logs:</strong>
              <v-btn size="x-small" variant="text" class="ml-2" @click="debugLogs = []">Clear</v-btn>
              <div class="debug-logs bg-grey-darken-4 pa-2 rounded mt-1">
                <div v-for="(entry, index) in debugLogs" :key="index" class="text-caption text-white">
                  <span class="text-grey">{{ entry.timestamp.split('T')[1].split('.')[0] }}</span>
                  <span class="ml-2">{{ entry.message }}</span>
                  <span v-if="entry.data" class="text-yellow ml-1">{{ JSON.stringify(entry.data) }}</span>
                </div>
                <div v-if="debugLogs.length === 0" class="text-grey text-caption">No logs yet...</div>
              </div>
            </div>
          </v-card-text>
        </div>
      </v-expand-transition>
    </v-card>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { usePage } from '@inertiajs/vue3';
import { computed, ref, onMounted, onUnmounted, nextTick } from 'vue';
import axios from 'axios';

const page = usePage();
const currentUser = computed(() => page.props.auth?.user);

// State
const messages = ref([]);
const newMessage = ref('');
const sending = ref(false);
const connectionStatus = ref('connecting');
const onlineUsers = ref([]);
const showError = ref(false);
const errorMessage = ref('');
const messagesContainer = ref(null);
const debugLogs = ref([]);
const showDebug = ref(true);
const echoAvailable = ref(false);

// Chat channel reference
let chatChannel = null;

// Debug logging helper
const log = (message, data = null) => {
  const timestamp = new Date().toISOString();
  const logEntry = { timestamp, message, data };
  debugLogs.value.push(logEntry);
  console.log(`[Chat ${timestamp}]`, message, data || '');
};

// Initialize chat using global window.Echo
const initializeChat = () => {
  log('Checking for window.Echo...');
  
  if (!window.Echo) {
    log('ERROR: window.Echo is not available!');
    connectionStatus.value = 'error';
    errorMessage.value = 'Echo is not initialized. Check echo.js';
    showError.value = true;
    return;
  }

  echoAvailable.value = true;
  log('window.Echo is available');

  try {
    // Listen to connection state changes
    window.Echo.connector.pusher.connection.bind('connecting', () => {
      log('Pusher: connecting...');
      connectionStatus.value = 'connecting';
    });

    window.Echo.connector.pusher.connection.bind('connected', () => {
      log('Pusher: connected!', { socketId: window.Echo.socketId() });
    });

    window.Echo.connector.pusher.connection.bind('unavailable', () => {
      log('Pusher: unavailable');
      connectionStatus.value = 'error';
    });

    window.Echo.connector.pusher.connection.bind('failed', () => {
      log('Pusher: connection failed');
      connectionStatus.value = 'error';
      errorMessage.value = 'WebSocket connection failed';
      showError.value = true;
    });

    window.Echo.connector.pusher.connection.bind('disconnected', () => {
      log('Pusher: disconnected');
      connectionStatus.value = 'disconnected';
    });

    window.Echo.connector.pusher.connection.bind('error', (error) => {
      log('Pusher: error', error);
      connectionStatus.value = 'error';
      errorMessage.value = 'WebSocket error: ' + (error?.message || 'Unknown error');
      showError.value = true;
    });

    // Join the presence channel for chat
    log('Joining presence channel: chat');
    chatChannel = window.Echo.join('chat')
      .here((users) => {
        log('Channel joined - users here:', users);
        onlineUsers.value = users;
        connectionStatus.value = 'connected';
      })
      .joining((user) => {
        log('User joining:', user);
        onlineUsers.value.push(user);
      })
      .leaving((user) => {
        log('User leaving:', user);
        onlineUsers.value = onlineUsers.value.filter(u => u.id !== user.id);
      })
      .listen('.message.sent', (data) => {
        log('Message received:', data);
        messages.value.push(data);
        scrollToBottom();
      })
      .error((error) => {
        log('Channel error:', error);
        connectionStatus.value = 'error';
        errorMessage.value = 'Failed to connect to chat channel: ' + (error?.message || JSON.stringify(error));
        showError.value = true;
      });

    log('Channel subscription initiated');

  } catch (error) {
    log('Chat initialization error:', error);
    connectionStatus.value = 'error';
    errorMessage.value = 'Failed to initialize chat: ' + error.message;
    showError.value = true;
  }
};

// Send a message
const sendMessage = async () => {
  if (!newMessage.value.trim() || sending.value) return;

  sending.value = true;
  const messageText = newMessage.value;
  newMessage.value = '';

  try {
    log('Sending message...', { message: messageText });
    const response = await axios.post('/chat/send', {
      message: messageText,
    }, {
      headers: {
        'X-Socket-ID': window.Echo.socketId(),
      }
    });

    if (response.data.success) {
      log('Message sent successfully');
      messages.value.push(response.data.message);
      scrollToBottom();
    } else {
      log('Message send failed', response.data);
      throw new Error(response.data.error || 'Unknown error');
    }
  } catch (error) {
    log('Failed to send message:', error);
    errorMessage.value = 'Failed to send message. Please try again.';
    showError.value = true;
    newMessage.value = messageText;
  } finally {
    sending.value = false;
  }
};

// Format timestamp
const formatTime = (timestamp) => {
  const date = new Date(timestamp);
  return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
};

// Scroll chat to bottom
const scrollToBottom = () => {
  nextTick(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
    }
  });
};

// Lifecycle hooks
onMounted(() => {
  initializeChat();
});

onUnmounted(() => {
  if (chatChannel && window.Echo) {
    log('Leaving chat channel');
    window.Echo.leave('chat');
  }
});
</script>

<style scoped>
.chat-messages {
  height: 400px;
  overflow-y: auto;
  background-color: rgb(var(--v-theme-surface-variant), 0.3);
}

.message-wrapper {
  display: flex;
  flex-direction: column;
}

.message-wrapper.own-message {
  align-items: flex-end;
}

.message-wrapper:not(.own-message) {
  align-items: flex-start;
}

.message-bubble {
  max-width: 70%;
  background-color: rgb(var(--v-theme-surface));
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.own-message .message-bubble {
  background-color: rgb(var(--v-theme-primary));
  color: rgb(var(--v-theme-on-primary));
}

.own-message .message-bubble .text-medium-emphasis {
  color: rgba(var(--v-theme-on-primary), 0.7) !important;
}

.debug-logs {
  max-height: 200px;
  overflow-y: auto;
  font-family: monospace;
}
</style>
