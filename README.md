# Dev Config

Here is a repository for development-related configuration files, like:

* `.bashrc`
* `.bash_aliases`

...etc.

## Quick Start

This will **not** install anything. Just clone the repo in a fancy manner.

**SSH:**

```bash
source <(curl -sL https://raw.githubusercontent.com/ydhamija96/config/master/.cfg_scripts/config_quick_setup__ssh.sh)
```

**HTTPS:**

```bash
source <(curl -sL https://raw.githubusercontent.com/ydhamija96/config/master/.cfg_scripts/config_quick_setup__https.sh)
```

## Quick Install

Optional. After running the quick start, this will install all the stuff I like. **Warning**: This will ruin your current setup.

**Ubuntu:**

```bash
~/.cfg_scripts/config_quick_install__ubuntu.sh
```

**Mac OS:**

```bash
~/.cfg_scripts/config_quick_install__mac.sh
```

## Manual Setup

What works best is to follow the method of the quickstart, which I found in [this article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

This will set up a git repository in the folder `~/.cfg` with a detached working tree. This way, you can treat your home directory if as if it were a git repository
-- using the `config` command, instead of `git` -- and it won't do crazy stuff like interfere with your other git repositories.

### Notes

- Do **not** use the `config add .` command. This will add all the untracked files in your home directory, which is **everything**.
    - Instead, add things individually using `config add <file>`.
    - This also applies to other stuff like `config commit -a`.
    - If you do this accidentally, you'll have to `Ctrl+C` out of it while it's stuck, or unstage all the files you added if it somehow succeeds.
