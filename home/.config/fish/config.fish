if status is-interactive
    set -g theme_date_format "+%Y-%m-%d %H:%M:%S"
    set -g fish_prompt_pwd_dir_length 0

    if test -e {$HOME}/.homesick/repos/homeshick/homeshick.fish
        source {$HOME}/.homesick/repos/homeshick/homeshick.fish
    end

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

    # TODO: check deno exists
    set -x DENO_INSTALL {$HOME}/.deno
    set -x PATH {$DENO_INSTALL}/bin $PATH
end
