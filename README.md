<div align="center">
  <h1 align="center"></h1>
  <p align="center">
    <a href="https://github.com/evolveart">
        <img src="https://img.shields.io/badge/Github-4078c0?style=for-the-badge&logo=github&logoColor=white">
    </a>
    <a href="https://twitter.com/intent/follow?screen_name=0xevolve">
        <img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white">
    </a>       
  </p>
  <h3 align="center">Implementation of fast exponentiation algorithm <a href="https://github.com/makerdao/xdomain-dss/blob/7668a2db829de4e6de4d543067a969708d798187/src/Pot.sol#L92">by MakerDAO</a>.</h3>
</div>

## Usage

> ## ⚠️ WARNING! ⚠️
>
> This repo contains highly experimental code.
> Expect rapid iteration.
> **Use at your own risk.**

### Set up the project

#### 📦 Install the requirements

- [protostar](https://github.com/software-mansion/protostar)

### ⛏️ Compile

```bash
protostar build
```

### 🌡️ Test

```bash
# Run all tests
protostar test

# Run only unit tests
protostar test tests/units

# Run only integration tests
protostar test tests/integrations
```

### 💋 Format code

```bash
cairo-format -i src/**/*.cairo tests/**/*.cairo
```

## 📄 License

**rpow** is released under the [MIT](LICENSE).
