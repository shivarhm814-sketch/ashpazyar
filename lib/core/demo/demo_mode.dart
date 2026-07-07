/// When true, the app runs fully offline against in-memory sample data
/// instead of the real (not-yet-deployed) backend — used for the public
/// portfolio/demo build. Enable at build time with:
///   flutter build web --dart-define=DEMO_MODE=true
const bool isDemoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);
