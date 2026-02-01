# Homebrew Tap: ss

This is a Homebrew tap for [ss](https://github.com/aaa2015/myiosss) - a Linux `ss` command implementation for macOS.

## Installation

```bash
# Add the tap
brew tap aaa2015/ss

# Install ss
brew install aaa2015/ss/ss

# Use it
ss -tulnp
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| ss | Socket statistics tool for macOS (Linux ss command clone) |

## Usage

```bash
# Show listening TCP/UDP sockets with process info
ss -tulnp

# Show established connections
ss -t state established

# Show help
ss -h
```

## More Information

- [GitHub Repository](https://github.com/aaa2015/myiosss)
- [Issue Tracker](https://github.com/aaa2015/myiosss/issues)

## License

MIT License
