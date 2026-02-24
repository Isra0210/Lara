# LARA -- Chat IA em Flutter

LARA é um aplicativo Flutter que implementa autenticação (e-mail/senha e
Google) e uma experiência de chat com uma assistente de IA. O projeto
segue **Clean Architecture**, usa **GetX** para estado/rotas/DI,
**Firebase** para autenticação e **Sqflite** para persistência local.

---

## 📁 Estrutura do Projeto

    lib/
    ├── core/                # Constantes, erros, tema, utils, widgets compartilhados
    ├── data/                # Datasources (local/remoto), models e repositórios (impl)
    ├── domain/              # Entities, contratos de repositório e usecases (camada pura)
    ├── presentation/        # UI, controllers (GetX) e bindings
    ├── firebase_options.dart
    ├── lara_app.dart
    └── main.dart

### Descrição das camadas

- **core/**
  - Contém código compartilhado pela aplicação inteira:
    - Constantes
    - Tratamento de erros
    - Tema
    - Utils
    - Widgets reutilizáveis
- **data/**
  - Implementações concretas:
    - Datasources locais (Sqflite, preferências, etc)
    - Datasources remotos (Firebase, Gemini API)
    - Models (DTOs)
    - Implementações dos repositórios do domain
- **domain/**
  - Camada pura de regras de negócio:
    - Entities
    - Contratos de repositório (interfaces)
    - UseCases
  - Não depende de Flutter, GetX ou qualquer framework externo
- **presentation/**
  - Camada de UI e estado:
    - Páginas (UI)
    - Controllers (GetX)
    - Bindings (injeção de dependência)
    - Navegação
- **firebase_options.dart**
  - Configuração gerada pelo FlutterFire para conectar ao Firebase
- **lara_app.dart**
  - Widget raiz da aplicação (MaterialApp / GetMaterialApp)
- **main.dart**
  - Ponto de entrada da aplicação

---

## 🚀 Como rodar o projeto do zero

### Pré-requisitos

- Flutter instalado (`flutter --version`)
- Android Studio e/ou Xcode
- Firebase CLI e FlutterFire CLI
- Um projeto criado no Firebase

### Passo a passo

1.  Clone o repositório:

```
git clone https://github.com/Isra0210/Lara.git
cd lara
```

2.  Instale as dependências:

```
flutter pub get
```

3.  Configure o Firebase (se necessário):

```
dart pub global activate flutterfire_cli
flutterfire configure
```

4.  Verifique os arquivos nativos:

```
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
```

5.  iOS (se estiver no macOS):

```
cd ios
pod install
cd ..
```

6.  Rode o app:

```
flutter run
```

---

## 🔐 Como configurar o Login com Google

### No Firebase Console

1.  Vá em **Authentication → Sign-in method**
2.  Ative o provedor **Google**

### Android

1.  Gere SHA-1 e SHA-256:

```
cd android
./gradlew signingReport
```

2.  Adicione os fingerprints no:

- Firebase Console → Project Settings → Your Apps → Android

3.  Baixe novamente o `google-services.json` e coloque em:

- `android/app/google-services.json`

### iOS

1.  Baixe o `GoogleService-Info.plist` do Firebase
2.  Coloque em:

- `ios/Runner/GoogleService-Info.plist`

3.  Abra o projeto no Xcode e confirme que o arquivo está no target
    **Runner**
4.  Verifique se o `Info.plist` contém o URL Scheme com o
    `REVERSED_CLIENT_ID`
5.  Rode:

```
cd ios
pod install
cd ..
```

---

## 🤖 Como configurar a chave da IA

A chave da IA fica em:

    lib/core/constants/app_constants.dart

Exemplo:

```dart
class AppConstants {
  static const geminiApiKey = 'SUA_CHAVE_AQUI';
}
```

### Recomendação

Use `--dart-define` para não commitar a chave:

    flutter run --dart-define=GEMINI_API_KEY="SUA_CHAVE"

E no código:

```dart
const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
```

A integração com a IA está em:

    lib/data/datasources/remote/gemini_datasource.dart

---

## 🧪 Como testar o app

### Autenticação

- [ ] Login com e-mail/senha válido
- [ ] Login com e-mail/senha inválido
- [ ] Login com Google
- [ ] Persistência de sessão ao reabrir o app

### Home / Chats

- [ ] Criar nova conversa
- [ ] Listar conversas recentes
- [ ] Abrir conversa existente

### Chat

- [ ] Enviar mensagem do usuário
- [ ] Receber resposta da LARA
- [ ] Persistir mensagens localmente
- [ ] Reabrir conversa e continuar histórico

### Configurações

- [ ] Alterar tema
- [ ] Alterar personalidade
- [ ] Persistir preferências após reiniciar o app

---

## 🧱 Decisões técnicas

- **Clean Architecture**
  - Separação em `domain`, `data` e `presentation`
  - Domain independente de frameworks
- **GetX**
  - Usado para:
    - Gerenciamento de estado
    - Injeção de dependência (Bindings)
    - Navegação
- **Persistência local**
  - Usando **Sqflite** para chats e mensagens
  - Preferências locais para tema e personalidade
- **Separação de fontes de dados**
  - Remoto: Firebase Auth + Gemini API
  - Local: Sqflite + preferências
- **Tratamento de erros centralizado**
  - Em `lib/core/errors`
  - Permite padronizar falhas e mensagens exibidas na UI

---

## 🛠️ Troubleshooting

- ❌ Login com Google não funciona:
  - Verifique SHA-1/SHA-256 no Firebase
  - Confira `google-services.json` / `GoogleService-Info.plist`
- ❌ iOS não compila:
  - Rode `pod install`
  - Verifique se o `GoogleService-Info.plist` está no target Runner
- ❌ IA não responde:
  - Verifique a chave da API em `AppConstants`
  - Verifique a implementação em `gemini_datasource.dart`

---

Projeto de estudo / POC.
