// Waterfox Hardening Configuration
// Privacy and security settings for maximum protection

// Disable telemetry
user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 0);
user_pref("datareporting.policy.dataSubmissionPolicyNotifiedTime", 0);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);

// Disable pocket, sponsored content
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.preload", false);
user_pref("browser.newtabpage.activity-stream.enabled", false);

// HTTPS enforcement
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// Tracking protection
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.socialtracking.block_cookies.enabled", true);

// Fingerprinting protection
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.resistFingerprinting.letterboxing", true);

// Disable DRM
user_pref("media.eme.enabled", false);

// Disable WebGL
user_pref("webgl.disabled", true);

// Disable canvas fingerprinting
user_pref("privacy.canvas.extraction_allowed", false);

// Disable plugin enumeration
user_pref("plugins.enumerable_names", "");

// Disable hardware acceleration
user_pref("layers.acceleration.disabled", true);

// DNS over HTTPS
user_pref("network.trr.mode", 2);
user_pref("network.trr.uri", "https://dns.cloudflare.com/dns-query");

// Disable prefetching
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("network.predictor.enabled", false);

// Disable link prefetching
user_pref("network.http.speculative-parallel-limit", 0);

// First-party isolation
user_pref("privacy.firstparty.isolate", true);
user_pref("privacy.firstparty.isolate.restrict_opener_access", true);

// Disable form autofill
user_pref("browser.formfill.enable", false);

// Disable password manager
user_pref("signon.rememberSignons", false);
user_pref("signon.generation.available", false);

// Clear cookies on exit
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.siteSettings", true);

// History/cache privacy
user_pref("privacy.history.custom", true);
user_pref("privacy.cpd.formdata", true);
user_pref("privacy.cpd.history", true);
user_pref("privacy.cpd.cache", true);

// Disable geolocation
user_pref("geo.enabled", false);
user_pref("geo.provider.use_corelocation", false);

// Disable notification
user_pref("dom.webnotifications.enabled", false);

// Disable push notifications
user_pref("dom.push.enabled", false);
