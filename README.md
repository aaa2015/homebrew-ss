# Homebrew Tap: aaa2015/ss

This is a Homebrew tap for personal tools.

## Installation

```bash
# Add the tap
brew tap aaa2015/ss
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| myss | Socket statistics tool for macOS (Linux ss command clone) |
| mycode | AI coding assistant with TUI interface |

## mycode

```bash
# Install
brew install aaa2015/ss/mycode

# Launch interactive TUI
mycode

# Show help
mycode --help
```

## myss

```bash
# Install
brew install aaa2015/ss/myss

# Show listening TCP/UDP sockets with process info
myss -tulnp

# Show established connections
myss -t state established
```

## More Information

- [mycode Repository](https://github.com/aaa2015/mycode)
- [myss Repository](https://github.com/aaa2015/myiosss)

## License

MIT License
