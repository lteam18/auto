# install

# Install the libarry

```bash
bash <(curl https://lteam18.github.io/auto/install-bash-lib.sh)
```

## How to source a library

```bash
# For Linux
source <(curl https://lteam18.github.io/auto/bash-lib/chalk.sh)

# For MacOS/Unix
RF=/tmp/$RANDOM; curl https://lteam18.github.io/auto/bash-lib/chalk.sh > $RF; source $RF; rm $RF;

# For MacOS/Unix
function source.url() { local RF=/tmp/$RANDOM; curl $1 > $RF; source $RF; rm $RF; }
source.url https://lteam18.github.io/auto/bash-lib/chalk.sh
```

## How to run a script

For example, if we want to install node.

```bash
curl https://lteam18.github.io/auto/install/node.sh | bash
```

## How to cache the bash facility

No git. curl file list, and then install

1. Download the script, `install.script`
2. install, setup `$HOME/.bashrc` and `$HOME/.lteam18/`, `$HOME/.lteam18/index.sh`
3. cache the scripts in `$HOME/.lteam18`
4. `lt18.auto.install`, `lt18.auto.lib chalk`

