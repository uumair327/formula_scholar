import '../../domain/domain.dart';

class HttpAiProviderFactory implements AiProviderFactory {
  HttpAiProviderFactory(List<AiProviderClientPort> clients)
    : _clients = {for (final client in clients) client.provider: client};

  final Map<AiProviderType, AiProviderClientPort> _clients;

  @override
  AiProviderClientPort clientFor(AiProviderType provider) {
    final client = _clients[provider];
    if (client == null) {
      throw StateError('AI provider ${provider.id} is not registered.');
    }
    return client;
  }
}
