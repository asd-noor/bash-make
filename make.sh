#!/usr/bin/env bash

build() {
    echo 'building'
    sleep 2
    echo 'finished'
}

push() {
    echo 'pushing'
    sleep 1
    echo 'pushed'
}

debug() {
    echo 'debugging'
    sleep 3
    echo 'debug finished'
}

declare -A cmds=([b]=build [p]=push [d]=debug)

# App {{{
cmdshist=""
invalidopt=""

_print_cmds() {
    printf "\n\e[1mInteractive Make\e[0m: (dir: %s)\n\n" "$PWD"
    printf "\e[1mCommands\e[0m:\n"

    local nl=0
    for i in "${!cmds[@]}"; do
        [[ $nl -eq 2 ]] && { printf "\n"; nl=0; }
        local v="\e[33m$i\e[0m: ${cmds[$i]}"
        printf "    \e[33m%s\e[0m: %-9s" "$i" "${cmds[$i]}"
        nl=$((nl + 1))
    done
}

_print_history() {
    printf "\n\nHistory:%s\n" "$cmdshist"
    [[ -z "$invalidopt" ]] || {
        printf "Invalid option: %s\n" "$invalidopt"
        invalidopt=""
    }
}

_append_hist() {
    cmdshist="$cmdshist $1"
    printf "\nPress any key to continue.."
    read -n1
}

_summary() {
    clear

    if [[ "$cmdshist" != "" ]]; then
        printf "\n%s invocation history\n" "$0"
        # i=1
        for word in $cmdshist; do
            echo "    - $word"
            # echo "    $i. $word"
            # i=$((i+1))
        done
        printf "\n"
    fi
}

while true; do
    clear

    _print_cmds
    _print_history

    read -r -n1 -p "Pick command (q to quit): " chosen
    printf "\n"
    [[ "$chosen" = "q" ]] && break

    if [[ ${cmds[$chosen]+_} ]]; then
        ${cmds[$chosen]}
        _append_hist "${cmds[$chosen]}"
        continue
    fi

    invalidopt="$chosen"
done

_summary
# }}}

# vim: set filetype=bash foldmethod=marker foldlevel=0:
