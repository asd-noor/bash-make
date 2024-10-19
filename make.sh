#!/usr/bin/env bash
# vim: set filetype=bash foldmethod=marker foldlevel=0:

# Helpers {{{
declare -A cmds
cmdshist=""
invalidopt=""

_clearscreen() {
    clear
    printf "\n%s (dir: %s)\n\n" "$0" "$PWD"
}

_print_cmds() {
    printf "Commands:\n"
    for i in "${!cmds[@]}"; do printf '    %s: %s\n' "$i" "${cmds[$i]}"; done
}

_print_history() {
    printf "\nHistory:%s\n" "$cmdshist"
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
# }}}

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

while true; do
    _clearscreen

    cmds=([b]=build [p]=push)
    _print_cmds

    _print_history
    read -r -n1 -p "Pick command (q to quit): " chosen
    printf "\n"

    case "$chosen" in
        b) build ;;
        p) push ;;
        q) break ;;
        *) invalidopt="$chosen" ; continue ;;
    esac

    _append_hist "${cmds[$chosen]}"
done

printf "\n"
