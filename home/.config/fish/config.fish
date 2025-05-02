if status is-interactive
    set -g theme_date_format "+%Y-%m-%d %H:%M:%S"
    set -g fish_prompt_pwd_dir_length 0

    if test -e {$HOME}/.homesick/repos/homeshick/homeshick.fish
        source {$HOME}/.homesick/repos/homeshick/homeshick.fish
    end

    # golang
    mkdir -p {$HOME}/.go
    set -x GOPATH {$HOME}/.go
    set -x PATH {$PATH} {$GOPATH}/bin
    set -x PATH {$PATH} /usr/local/go/bin

    # rust
    set -x PATH {$PATH} {$HOME}/.cargo/bin


    # nvim
    abbr -a vim nvim

    # ls
    abbr -a l ls
    abbr -a la ls -la
    abbr -a al ls -la

    # cp
    abbr -a cp "cp -i"

    switch (uname)
    case 'Darwin'
        if test -f '/opt/homebrew/bin/brew'
            eval (/opt/homebrew/bin/brew shellenv)
        end
    case 'Linux'
        switch (uname -r)
        case '*microsoft*'
            set -x SSH_AUTH_SOCK {$HOME}/.ssh/agent.sock
            set ALREADY_RUNNING (ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo {$status})
            if test {$ALREADY_RUNNING} -ne 0
                if test -S {$SSH_AUTH_SOCK}
                    echo "removing previous socket..."
                    rm $SSH_AUTH_SOCK
                end
                echo "Starting SSH-Agent relay..."
                # TODO: automate install npiperelay
                setsid socat UNIX-LISTEN:{$SSH_AUTH_SOCK},fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &
            end
        end
  end

  # TODO: check deno exists
  set -x DENO_INSTALL {$HOME}/.deno
  set -x PATH {$DENO_INSTALL}/bin $PATH

  #######
  # asdf
  #######
  # ASDF configuration code
  if which -s asdf
    if test -z $ASDF_DATA_DIR
      set _asdf_shims "$HOME/.asdf/shims"
    else
      set _asdf_shims "$ASDF_DATA_DIR/shims"
    end
  end

  # Do not use fish_add_path (added in Fish 3.2) because it
  # potentially changes the order of items in PATH
  if not contains $_asdf_shims $PATH
      set -gx --prepend PATH $_asdf_shims
  end
  set --erase _asdf_shims

  # aqua
  if which -s aqua
    set -x PATH $(aqua root-dir)/bin $PATH
  end

  if which -s npm
    set -x PATH $(npm prefix --location=global)/bin $PATH
  end

  set -x GPG_TTY (tty)

	if test -e .fish_config.local
    source .fish_config.local
	end
end
