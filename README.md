# install

# Install the libarry

```bash
source /dev/stdin <<<(curl https://lteam18.github.io/install-bash-lib.sh)
```

## How to source a library

```bash
source /dev/stdin <<<(curl https://lteam18.github.io/bash-lib/chalk.sh)
```

## How to run a script

For example, if we want to install node.

```bash
curl https://lteam18.github.io/install/node.sh | bash
```

## How to cache the bash facility

No git. curl file list, and then install 

1. Download the script, `install.script`
2. install, setup `$HOME/.bashrc` and `$HOME/.lteam18/`, `$HOME/.lteam18/index.sh`
3. cache the scripts in `$HOME/.lteam18`
4. `lt18.auto.install`, `lt18.auto.lib chalk`

```bash
source /dev/stdin <<<(curl https://lteam18.github.io/bash-lib/chalk.sh)
```

