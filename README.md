# Dev Container Features

## nnn

Build nnn from source and installs

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/ichirou2910/devcontainer-features/nnn:1": {
      "version": "4.9",
      "makeOpts": "O_NERD=1",
    },
  },
}
```
