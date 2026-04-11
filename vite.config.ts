import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

// @ts-expect-error process is a nodejs global
const host = process.env.TAURI_DEV_HOST;

export default defineConfig({
  plugins: [react(), tailwindcss()],
  clearScreen: false,
  server: {
    port: 1420,
    strictPort: true,
    host: host || false,
    hmr: host ? { protocol: "ws", host, port: 1421 } : undefined,
    watch: { ignored: ["**/src-tauri/**"] },
  },
  optimizeDeps: {
    include: ["@xterm/xterm", "@xterm/addon-fit", "@xterm/addon-web-links"],
  },
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          // Monaco dans son propre chunk — ~4MB isolé
          "monaco-editor": ["monaco-editor"],
          "@monaco-editor/react": ["@monaco-editor/react"],
          // xterm séparé
          "xterm": ["@xterm/xterm", "@xterm/addon-fit", "@xterm/addon-web-links"],
          // React core
          "react-vendor": ["react", "react-dom"],
        },
      },
    },
    // Augmenter le seuil d'avertissement pour Monaco (normal qu'il soit gros)
    chunkSizeWarningLimit: 5000,
  },
});
