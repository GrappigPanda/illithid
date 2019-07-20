# Illithid

In short, Illithid aims to allow you to programatically control server infrastructure.

So, each server you create will have a corresponding pid/Genserver which you can directly interact with.


## How to use

TODO(ian): Add some more info when the API is a little more fleshed out

## Installation

```elixir
def deps do
  [
    {:illithid, "~> 0.1.0"}
  ]
end
```

## Remaining Work

### High Priority
- [ ] Jitter and backoff to requests
- [ ] Worker self updater (See: [https://github.com/Ianleeclark/illithid/issues/11](Issue #11))

### Low Priority
- [ ] Add AWS (EC2) support
- [ ] Add Google Cloud (Compute Engine) support
- [ ] Add corresponding Azure support

