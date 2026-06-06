enum AiProviderType {
  openai('openai', 'OpenAI', 'gpt-4.1-mini'),
  claude('claude', 'Claude', 'claude-3-5-sonnet-latest'),
  gemini('gemini', 'Gemini', 'gemini-flash-latest');

  const AiProviderType(this.id, this.label, this.defaultModel);

  final String id;
  final String label;
  final String defaultModel;

  static AiProviderType fromId(String? id) {
    return AiProviderType.values.firstWhere(
      (provider) => provider.id == id,
      orElse: () => AiProviderType.openai,
    );
  }
}
