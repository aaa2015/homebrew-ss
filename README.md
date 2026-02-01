# Homebrew Tap: ss-apple

This is a Homebrew tap for [ss-apple](https://github.com/aaa2015/myiosss) - a Linux `ss` command implementation for macOS.

## Installation

```bash
# Add the tap
brew tap aaa2015/ss

# Install ss-apple
brew install ss-apple

# Use it
ss-apple -tulnp
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| ss-apple | Socket statistics tool for macOS (Linux ss command clone) |

## Usage

```bash
# Show listening TCP/UDP sockets with process info
ss-apple -tulnp

# Show established connections
ss-apple -t state established

# Show help
ss-apple -h
```

## More Information

- [GitHub Repository](https://github.com/aaa2015/myiosss)
- [Issue Tracker](https://github.com/aaa2015/myiosss/issues)

## License

MIT License
