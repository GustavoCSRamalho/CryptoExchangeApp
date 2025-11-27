# 🚀 CryptoExchange App

<div align="center">

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Architecture](https://img.shields.io/badge/Architecture-VIP--C-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

**Um aplicativo iOS moderno para visualização de exchanges de criptomoedas e seus ativos**

[Características](#-características) •
[Arquitetura](#-arquitetura) •
[Instalação](#-instalação) •
[Configuração](#-configuração-da-api) •
[Testes](#-testes) •
[Tecnologias](#-tecnologias)

</div>

---

## ✨ Características

- 📊 **Lista de Exchanges** - Visualize as principais exchanges de criptomoedas com volume de negociação
- 💎 **Detalhes Completos** - Informações detalhadas incluindo taxas, moedas suportadas e data de lançamento
- 🎨 **Design System** - Interface moderna e consistente seguindo as melhores práticas de UI/UX
- 🔄 **Pull to Refresh** - Atualize os dados com um simples gesto
- 🌐 **Links Externos** - Acesse diretamente o website das exchanges
- ⚡ **Performance** - Carregamento otimizado de imagens com cache (Kingfisher)
- 🧪 **100% Testado** - Cobertura completa de testes unitários e de UI
- 🌍 **Internacionalização** - Suporte para múltiplos idiomas (EN, PT-BR)
- 🎯 **Offline-First** - Sistema de mocks para desenvolvimento e testes

---

## 🏗 Arquitetura

Este projeto utiliza **VIP-C (Clean Swift)**, uma arquitetura unidirecional que garante separação clara de responsabilidades e facilita testes.

### Estrutura VIP-C

```
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│             │      │              │      │             │
│ViewController│──────▶│  Interactor  │──────▶│  Presenter  │
│             │      │              │      │             │
└──────┬──────┘      └──────┬───────┘      └──────┬──────┘
       │                    │                     │
       │                    ▼                     │
       │             ┌──────────────┐             │
       │             │              │             │
       │             │    Worker    │             │
       │             │              │             │
       │             └──────────────┘             │
       │                                          │
       └──────────────────────────────────────────┘
```

### Camadas do Projeto

```
CryptoExchangeApp/
├── 📁 Scenes/
│   ├── ExchangeList/          # Lista de exchanges
│   │   ├── ExchangeListViewController.swift
│   │   ├── ExchangeListInteractor.swift
│   │   ├── ExchangeListPresenter.swift
│   │   ├── ExchangeListWorker.swift
│   │   ├── ExchangeListCoordiantor.swift
│   │   ├── ExchangeListFactory.swift
│   │   └── ExchangeVIPModels.swift
│   │
│   └── ExchangeDetail/        # Detalhes da exchange
│       ├── ExchangeDetailViewController.swift
│       ├── ExchangeDetailInteractor.swift
│       ├── ExchangeDetailPresenter.swift
│       ├── ExchangeDetailWorker.swift
│       ├── ExchangeDetailFactory.swift
│       └── ExchangeDetailModels.swift
│
├── 📁 Models/
│   ├── Exchange.swift          # Modelos de dados
│   ├── ExchangeDetail.swift
│   ├── ExchangeList.swift
│   ├── ExchangeViewModel.swift
│   ├── NetworkError.swift
│   └── Response.swift
│
├── 📁 Networking/
│   ├── NetworkService.swift
│   └── MockNetworkService.swift
│
├── 📁 UI/
│   ├── Components/
│   │   ├── ExchangeTableViewCell.swift
│   │   ├── ExchangeDetailsTableViewCell.swift
│   │   └── ErrorView.swift
│   │
│   └── DesignSystem/
│       └── DesignSystem.swift
│
├── 📁 Resources/
│   ├── Localizable.strings     # Internacionalização
│   └── Assets.xcassets
│
└── 📁 Helpers/
    ├── Localizable.swift
    └── UITestingHelper.swift
    └── Mock/
        ├── MockNetworkService.swift
        └── AsyncExecutorMock.swift
```

### Fluxo de Dados VIP-C

1. **ViewController** captura ações do usuário
2. **Interactor** processa a lógica de negócio
3. **Worker** realiza chamadas à API
4. **Presenter** formata dados para apresentação
5. **ViewController** atualiza a UI

---

## 📦 Instalação

### Pré-requisitos

- 🖥 macOS 13.0+ (Ventura)
- 📱 Xcode 15.0+
- 🎯 iOS 15.0+
- 📦 Swift Package Manager

### Dependências

**Swift Package Manager**:

```
https://github.com/onevcat/Kingfisher.git
https://github.com/Alamofire/Alamofire.git
https://github.com/SnapKit/SnapKit.git
```

### Passos de Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/crypto-exchange-app.git
cd crypto-exchange-app
```

2. **Instale as dependências**

Usando SPM:
```bash
# Abra o projeto no Xcode
# File > Add Packages > Cole as URLs das dependências
```

3. **Configure a API Key** (veja seção abaixo)

4. **Build e Run**
```bash
⌘ + R
```

---

## 🔑 Configuração da API

### Obtendo sua API Key

1. Acesse [CoinMarketCap API](https://coinmarketcap.com/api/)
2. Crie uma conta gratuita
3. Acesse o [Dashboard](https://pro.coinmarketcap.com/account)
4. Copie sua **API Key**

### Configurando no Projeto

#### Opção 1: Environment Variables (Recomendado)

1. No Xcode, vá em: `Product` → `Scheme` → `Edit Scheme`
2. Selecione `Run` → `Arguments`
3. Adicione em **Environment Variables**:

```
Name: COINMARKETCAP_API_KEY
Value: SUA_API_KEY_AQUI
```

![API Key Configuration](screenshots/api-key-setup.png)

#### Opção 2: Arquivo de Configuração

1. Crie uma pasta Supporting Files, depois Configuration, la voce adicione dois arquivos,`Debug.xcconfig` e `Release.xcconfig`:

```xcconfig
// Config.xcconfig
API_KEY = sua_api_key_aqui sem aspas
```

2. Depois disso, ele irá setar o valor em CMC_API_KEY dentro do Info.plist, ou se voce preferir, adicione
a chave no valor la dentro:


**Solução para desenvolvimento:**

Use o **modo mock** para testar o app sem API:

```swift
// Em Scheme → Arguments → Environment Variables
[
    MOCK_SUCCESS = 1,
    UI_TESTING = 1
]
```

ou se quiser testar os erros:

[
    "UI_TESTING": "1",
    "MOCK_ERROR": "1",
    "MOCK_ERROR_TYPE": "401"
]

---

## 🎨 Design System

O projeto utiliza um Design System centralizado para garantir consistência visual.

### Cores

```swift
DesignSystem.Colors.primary           // #1E40AF - Azul primário
DesignSystem.Colors.secondary         // #3B82F6 - Azul secundário
DesignSystem.Colors.background        // #FFFFFF - Fundo principal
DesignSystem.Colors.textPrimary       // #111827 - Texto principal
DesignSystem.Colors.success           // #10B981 - Verde sucesso
DesignSystem.Colors.error             // #EF4444 - Vermelho erro
```

### Tipografia

```swift
DesignSystem.Typography.titleLarge    // 28pt Bold
DesignSystem.Typography.titleSection  // 20pt Semibold
DesignSystem.Typography.subtitle      // 16pt Semibold
DesignSystem.Typography.body          // 15pt Regular
```

### Espaçamento

```swift
DesignSystem.Spacing.tiny            // 4pt
DesignSystem.Spacing.small           // 8pt
DesignSystem.Spacing.medium          // 16pt
DesignSystem.Spacing.large           // 24pt
```

---

## 🧪 Testes

### Executando Testes

```bash
# Todos os testes
⌘ + U

# Testes específicos
⌘ + U (com arquivo selecionado)
```

### Cobertura de Testes

- ✅ **Unit Tests** - 100% de cobertura nas camadas VIP-C
- ✅ **UI Tests** - Fluxos completos de navegação
- ✅ **Integration Tests** - Testes de worker e networking
- ✅ **Error Handling Tests** - Todos os cenários de erro

### Estrutura de Testes

```
CryptoExchangeAppTests/
├── ExchangesInteractorTests.swift
├── ExchangesPresenterTests.swift
├── ExchangeDetailInteractorTests.swift
├── ExchangeDetailPresenterTests.swift
└── ErrorMessagesTests.swift

CryptoExchangeAppUITests/
├── CryptoExchangeAppUITests.swift
├── ExchangeDetailUITests.swift
└── ErrorHandlingUITests.swift
```

### Configurando Testes com Mocks

Para executar testes de UI com dados mockados:

1. Abra `Product` → `Scheme` → `Edit Scheme`
2. Selecione `Test` → `Arguments`
3. Adicione:

**Launch Arguments:**
```
UI-TESTING
-AppleLanguages (en)
-AppleLocale en_US
```

**Environment Variables:**
```
MOCK_SUCCESS = 1
```

### Testando Diferentes Cenários de Erro

**Launch Arguments:**
```
UI-TESTING
MOCK-NETWORK-ERROR
```

**Environment Variables:**
```
MOCK_ERROR_TYPE = 401    # Erro de autenticação
MOCK_ERROR_TYPE = 403    # Acesso negado
MOCK_ERROR_TYPE = 429    # Rate limit
MOCK_ERROR_TYPE = 500    # Erro do servidor
```

---

## 🛠 Tecnologias

### Core

- **Swift 5.9** - Linguagem de programação
- **iOS 15.0+** - Plataforma alvo
- **UIKit** - Framework de UI
- **Foundation** - APIs fundamentais

### Arquitetura

- **VIP-C (Clean Swift)** - Arquitetura principal
- **Protocol-Oriented Design** - Abstração e testabilidade
- **Dependency Injection** - Gerenciamento de dependências

### Networking

- **Alamofire** - Requisicoes
- **Codable** - Serialização JSON
- **Result Type** - Tratamento de erros

### UI/UX

- **SnapKit** - Auto Layout programático
- **Kingfisher** - Cache e carregamento de imagens
- **Custom Components** - Componentes reutilizáveis

### Testes

- **XCTest** - Framework de testes nativo
- **XCUITest** - Testes de interface
- **Mock Objects** - Objetos de teste

---

## 📊 API Endpoints Utilizados

### Exchange Listings (PAGO)
```
GET https://pro-api.coinmarketcap.com/v1/exchange/listings/latest
```
**Parâmetros:**
- `limit`: 50
- `sort`: volume_24h

**Resposta:**
```json
{
  "data": [{
    "id": 270,
    "name": "Binance",
    "slug": "binance",
    "num_market_pairs": 2000,
    "spot_volume_usd": 15000000000.0,
    "date_launched": "2017-07-14T00:00:00.000Z"
  }]
}
```

### Exchange Info (GRÁTIS)
```
GET https://pro-api.coinmarketcap.com/v1/exchange/info
```
**Parâmetros:**
- `id`: 270

**Resposta:**
```json
{
  "data": {
    "270": {
      "id": 270,
      "name": "Binance",
      "logo": "https://...",
      "description": "...",
      "maker_fee": 0.10,
      "taker_fee": 0.10,
      "urls": {
        "website": ["https://binance.com"]
      }
    }
  }
}
```

### Exchange Assets (PAGO)
```
GET https://pro-api.coinmarketcap.com/v1/exchange/assets
```
**Parâmetros:**
- `id`: 270

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 👨‍💻 Autor

**Gustavo Ramalho**

- GitHub: [@gustavoaramalho](https://github.com/GustavoCSRamalho?tab=repositories)
- LinkedIn: [Gustavo Ramalho](https://www.linkedin.com/in/gustavo-r-473a23111/)

---

## 🙏 Agradecimentos

- [CoinMarketCap](https://coinmarketcap.com) - API de dados de criptomoedas
- [Kingfisher](https://github.com/onevcat/Kingfisher) - Excelente biblioteca de cache de imagens
- [SnapKit](https://github.com/SnapKit/SnapKit) - DSL elegante para Auto Layout
- [Alamofire](https://github.com/SnapKit/SnapKit) - Para requisicoes
- [Clean Swift](https://clean-swift.com) - Arquitetura VIP-C

---

<div align="center">

**⭐ Se este projeto foi útil, considere dar uma estrela!**

Made with ❤️ by [Gustavo Ramalho](https://github.com/gustavoaramalho)

</div>
