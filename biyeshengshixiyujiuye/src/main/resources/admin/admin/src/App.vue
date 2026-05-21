<template>
  <div id="app" class="">
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: "app",
};
</script>

<style lang="scss">
  * {
    padding: 0;
    margin: 0;
  }
  html, body {
    width: 100%;
    height: 100%;
  }
  #app {
    height: 100%;
  }
  body {
    padding: 0;
    margin: 0;
    background-color: #1a1a2e;
    color: #e8eaf6;
    font-family: 'Inter', ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 14px;
    line-height: 1.5;
    letter-spacing: -0.007em;
  }
  .el-table th.el-table__cell {
    color: #000000 !important;
  }

  :root {
    /* Colors */
    --color-page-bg: #1a1a2e;
    --color-card-bg: #252540;
    --color-surface: #2a2a45;
    --color-border: #333355;
    --color-text-primary: #e8eaf6;
    --color-text-secondary: #a0aec0;
    --color-text-muted: #6b7280;
    --color-accent: #64b5f6;
    --color-accent-light: #90caf9;
    --color-accent-dark: #1e3a5f;
    --color-danger: #ef5350;
    --color-danger-bg: #3a1e2e;

    /* Typography */
    --font-primary: 'Inter', ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;

    /* Border Radius */
    --radius-cards: 12px;
    --radius-inputs: 6px;
    --radius-buttons: 6px;

    /* Shadows */
    --shadow-sm: rgba(0, 0, 0, 0.2) 0px 4px 6px -1px;
  }
</style>
