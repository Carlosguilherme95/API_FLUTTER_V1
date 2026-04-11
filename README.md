# API Flutter v1

## Como rodar o projeto

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Arquitetura de pastas (`lib/`)

```
lib/
├── main.dart          # Ponto de entrada: prepara o armazenamento local e sobe o app
├── app.dart           # Raiz visual: tema, nome das rotas, ligação entre telas
└── src/
    ├── http/          # Configuração do Dio (comunicação HTTP com sistemas externos)
    ├── routes/        # Constantes com o nome/caminho de cada rota
    ├── shared/        # Estruturas compartilhadas (cores, métricas, componentes, storage)
    ├── home/          # Módulo Home (consulta CEP, resultado, loading, lista recente, rota)
    └── history/       # Módulo History (só tela + controller do histórico salvo localmente)
```
