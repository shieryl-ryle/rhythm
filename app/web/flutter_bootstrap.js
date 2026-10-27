{{flutter_js}}
{{flutter_build_config}}

// Self-host the fallback font (web/fonts/roboto/...) so the page contacts no third party (BR-015).
_flutter.loader.load({
  config: {
    fontFallbackBaseUrl: "fonts/",
  },
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
});
