# API Flutter v1

Um app Flutter para consultar CEPs e endereços via ViaCEP, com histórico local, busca por CEP ou por endereço e abertura de rotas em mapas.

---

## Recursos

- Consulta de CEP pela API ViaCEP
- Busca por endereço por `UF + Cidade + Logradouro`
- Histórico local usando Hive
- Exibição do endereço resultante
- Abertura de rota para o último endereço consultado
- Suporte Android, iOS e web
- Geocodificação web via Google Maps API
- Tratamento de erros e mensagens amigáveis para o usuário

---

## Pré-requisitos

- Flutter SDK instalado e configurado
- Dispositivo/emulador Android ou iOS, ou navegador para web
- Internet ativa
- Opcional: chave de API do Google Maps para web, se quiser usar rotas/geocodificação diretamente no navegador

### Dependências principais

- `dio`
- `mobx`
- `flutter_mobx`
- `hive`
- `hive_flutter`
- `map_launcher`
- `geocoding`
- `geolocator`

---

## Instalação

1. Clone o repositório:

```bash
git clone <repo-url>
cd API_FLUTTER_V1
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Gere os arquivos MobX/Hive:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Executando

### Android / iOS

```bash
flutter run
```

### Web

```bash
flutter run -d chrome
```

> Para web, se o app usa geocodificação via Google Maps, configure a chave de API no `web/index.html`.

---

## Estrutura do projeto

```text
lib/
├── main.dart                    # Ponto de entrada: prepara storage local e inicia o app
├── app.dart                     # Raiz visual: tema, rotas e configuração geral
└── src/
    ├── http/                    # Configuração do Dio e cliente HTTP
    ├── routes/                  # Constantes de rotas
    ├── shared/                  # Componentes e utilitários compartilhados
    ├── home/                    # Tela principal de consulta, controller, serviços e UI
    │   ├── components/          # Widgets reutilizáveis do fluxo de busca
    │   ├── controller/          # Controller MobX do Home
    │   ├── model/               # Modelos de dados
    │   ├── repositories/        # Repositórios de API e histórico local
    │   └── service/             # Lógica de negócio de CEP/endereço
    └── history/                 # Tela e controller do histórico salvo
```

---

## Configurações importantes

### Web / Google Maps

Se executar no web e quiser usar rota ou geocodificação via Google Maps, confirme que:

- `web/index.html` contém o script do Google Maps com a chave de API
- a chave esteja corretamente configurada e autorizada para a API necessária
- `lib\src\home\service\home_cep_service.dart` também contém a chave de API no método `_geocodeWeb`

### Permissões de localização

Para Android/iOS, verifique se as permissões estão configuradas em:

- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

Isso é necessário para o `geolocator` obter a localização atual.

---

## Como funciona

- `HomeCepService` realiza consultas à API ViaCEP e controla cache/histórico
- `HomeController` gerencia o estado com MobX e contém ações de busca
- `CepSearchForm` cuida da entrada de CEP
- A UI alterna entre dois modos de busca: CEP ou Endereço
- O histórico é salvo e recuperado localmente com Hive

---

## Comandos úteis

- `flutter pub get`
- `dart run build_runner build --delete-conflicting-outputs`
- `flutter run`
- `flutter test`

---

## Notas

- Use `build_runner` sempre que alterar arquivos anotados com MobX/Hive
- O app oferece dois modos de busca: CEP e Endereço
- Os placeholders e mensagens mudam conforme o modo selecionado

---

## Contribuição

1. Crie uma branch com um nome descritivo
2. Faça commits pequenos e claros
3. Abra um pull request explicando as mudanças
