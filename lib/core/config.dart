class AppConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://opdbjfdzvntxbjrassqj.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_i540AAUwMcbpfHqEf_o1Zg_KTgIvD1Q',
  );
}
