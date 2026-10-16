#!/usr/bin/env node

/**
 * autotile.mjs - Automatic Tiling Direction Daemon for GlazeWM
 *
 * Emulates i3/Sway autotiling (dwindle / spiral / binary tree layout):
 * - Listens to GlazeWM IPC events over WebSocket (ws://localhost:6123)
 * - Whenever window focus changes, calculates the container's aspect ratio
 * - If width >= height: sets tiling direction to 'horizontal' (splits into columns)
 * - If height > width: sets tiling direction to 'vertical' (splits into rows)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const PID_FILE = path.join(__dirname, 'autotile.pid');

const GLAZEWM_WS_URL = process.env.GLAZEWM_IPC_URL || 'ws://localhost:6123';
const RECONNECT_INTERVAL_MS = 2000;
const DEBUG = process.argv.includes('--debug');

// Aspect ratio threshold (width / height). Default 1.0.
const thresholdArg = process.argv.find((a) => a.startsWith('--threshold='));
const RATIO_THRESHOLD = thresholdArg ? parseFloat(thresholdArg.split('=')[1]) : 1.0;

function log(...args) {
  if (DEBUG) console.log(`[autotile ${new Date().toLocaleTimeString()}]`, ...args);
}

// ---------------------------------------------------------------------------
// Single-instance PID management
// ---------------------------------------------------------------------------

function checkAndWritePid() {
  try {
    if (fs.existsSync(PID_FILE)) {
      const oldPid = parseInt(fs.readFileSync(PID_FILE, 'utf8').trim(), 10);
      if (!isNaN(oldPid) && oldPid !== process.pid) {
        try {
          process.kill(oldPid, 'SIGTERM');
          log(`Terminated previous autotile daemon (PID ${oldPid})`);
        } catch (e) {
          // Process was not running
        }
      }
    }
    fs.writeFileSync(PID_FILE, String(process.pid), 'utf8');
  } catch (err) {
    log('Warning: could not write PID file:', err.message);
  }
}

function cleanupPid() {
  try {
    if (fs.existsSync(PID_FILE)) {
      const recordedPid = parseInt(fs.readFileSync(PID_FILE, 'utf8').trim(), 10);
      if (recordedPid === process.pid) {
        fs.unlinkSync(PID_FILE);
      }
    }
  } catch (err) {
    // Ignore cleanup errors
  }
}

process.on('SIGINT', () => {
  log('Received SIGINT, shutting down...');
  cleanupPid();
  process.exit(0);
});

process.on('SIGTERM', () => {
  log('Received SIGTERM, shutting down...');
  cleanupPid();
  process.exit(0);
});

process.on('exit', cleanupPid);

checkAndWritePid();

// ---------------------------------------------------------------------------
// WebSocket Connection & Autotiling Logic
// ---------------------------------------------------------------------------

let ws = null;
let reconnectTimer = null;
let currentDirection = null;

function calculateTargetDirection(width, height) {
  if (!width || !height || height <= 0) return 'horizontal';
  const ratio = width / height;
  return ratio >= RATIO_THRESHOLD ? 'horizontal' : 'vertical';
}

function sendCommand(commandStr) {
  if (ws && ws.readyState === WebSocket.OPEN) {
    log('Sending command:', commandStr);
    ws.send(`command ${commandStr}`);
  }
}

function evaluateFocusedWindow(focused) {
  if (!focused) return;

  // Only manage tiling windows (ignore floating, minimized, or non-window containers)
  if (focused.type !== 'window') return;
  if (focused.state?.type && focused.state.type !== 'tiling') return;

  const { width, height, title } = focused;
  const targetDir = calculateTargetDirection(width, height);

  log(`Window: "${title?.trim() || 'Untitled'}" (${width}x${height}) -> target: ${targetDir}`);

  if (targetDir !== currentDirection) {
    currentDirection = targetDir;
    sendCommand(`set-tiling-direction ${targetDir}`);
  }
}

function handleMessage(rawMessage) {
  try {
    const msg = JSON.parse(rawMessage);

    // Initial query or direct query response
    if (msg.messageType === 'client_response') {
      if (msg.data?.focused) {
        evaluateFocusedWindow(msg.data.focused);
      } else if (msg.data?.tilingDirection) {
        currentDirection = msg.data.tilingDirection;
      }
      return;
    }

    // Event subscription broadcast
    if (msg.messageType === 'event_subscription') {
      const eventType = msg.data?.eventType;

      if (
        eventType === 'focus_changed' ||
        eventType === 'focused_container_moved' ||
        eventType === 'workspace_activated'
      ) {
        // Query the focused container with full geometry
        if (ws && ws.readyState === WebSocket.OPEN) {
          ws.send('query focused');
        }
      }
    }
  } catch (err) {
    if (DEBUG) console.error('Error handling message:', err);
  }
}

function connect() {
  if (reconnectTimer) {
    clearTimeout(reconnectTimer);
    reconnectTimer = null;
  }

  log(`Connecting to GlazeWM IPC at ${GLAZEWM_WS_URL}...`);

  try {
    ws = new WebSocket(GLAZEWM_WS_URL);

    ws.onopen = () => {
      log('Connected to GlazeWM IPC.');
      // Subscribe to all window management events
      ws.send('sub --events all');
      // Query current state immediately
      ws.send('query focused');
      ws.send('query tiling-direction');
    };

    ws.onmessage = (event) => {
      handleMessage(event.data);
    };

    ws.onclose = () => {
      log('Disconnected from GlazeWM IPC. Reconnecting in', RECONNECT_INTERVAL_MS, 'ms...');
      currentDirection = null;
      ws = null;
      scheduleReconnect();
    };

    ws.onerror = (err) => {
      log('WebSocket error:', err.message || err);
      ws?.close();
    };
  } catch (err) {
    log('Failed to create WebSocket:', err.message);
    scheduleReconnect();
  }
}

function scheduleReconnect() {
  if (!reconnectTimer) {
    reconnectTimer = setTimeout(connect, RECONNECT_INTERVAL_MS);
  }
}

// Start daemon
connect();
