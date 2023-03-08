# -----------------------------------------------------------------------------------------------------------
# ######################################## Docker Color Output Aliases ######################################
# -----------------------------------------------------------------------------------------------------------

# Docker Color Output (https://github.com/devemio/docker-color-output)

# The code in this section creates aliases for the following commands:
# * `dco` => `docker-color-output`
# * `docker` => `docker` + `docker-color-output` (in some situations)
#
# This allows us to perform normal `docker` invocations that automatically color the output for:
# * `docker images` (and its aliases)
# * `docker ps` (and its aliases)
#
# This code also filters the options that can be passed to the previous commands to color the output,
# because not all options generate an output that can be passed to `docker-color-output`.

# Alias for `docker-color-output`
alias dco="docker-color-output"

# Alias for `docker`
docker() {
    # ------------------------------ `docker` ------------------------------------
    if [ $# -eq 0 ]; then
        # If docker is called without params, simply invoke docker
        /usr/bin/docker
    # ----------------------------------------------------------------------------
    else
        # -------------------------------- di ------------------------------------
        # `docker images`
        if [ "$1" = "images" ]; then
            __di "${@:2}" # pass the [2, n] args
        # `docker image ls` | `docker image list`
        elif [ "$1" = "image" ] && [[ "$2" = @(ls|list) ]]; then
            __di "${@:3}" # pass the [3, n] args
        # ------------------------------------------------------------------------
        # -------------------------------- dps -----------------------------------
        # `docker ps`
				elif [ "$1" = "ps" ]; then
            __dps "${@:2}" # pass the [2, n] args
        # `docker container ps` | `docker container ls` | `docker container list`
        elif [ "$1" = "container" ] && [[ "$2" = @(ps|ls|list) ]]; then
            __dps "${@:3}" # pass the [3, n] args
        # ------------------------------------------------------------------------
        # -------------------------------- dcps ----------------------------------
        # `docker compose ps`
        elif [ "$1" = "compose" ] && [ "$2" = "ps" ]; then
            __dcps "${@:3}" # pass the [3, n] args
        # ------------------------------------------------------------------------
        # -------------------------------- other ---------------------------------
        else
            # Invoke docker with all args
            /usr/bin/docker "$@"
        fi
        # ------------------------------------------------------------------------
    fi
}

__di(){
    # ----------------------------------------- Supported options -------------------------------------------
    # Only the options listed here will be supported in conjuntion with `docker-color-output`
    #     di
    if [ $# -eq 0 ] || \
        # di -a | --all | --no-trunc
        ([ $# -eq 1 ] && [[ "$1" = @(-a|--all|--no-trunc) ]]) || \
        # di -f "{...}" | --filter "{...}"
        ([ $# -eq 2 ] && [[ "$1" = @(-f|--filter) ]]) || \
        # di -a --no-trunc | --all --no-trunc
        ([ $# -eq 2 ] && [[ "$1" = @(-a|--all) ]] && [ "$2" = "--no-trunc" ]) || \
        # di --no-trunc -a | --no-trunc --all
        ([ $# -eq 2 ] && [ "$1" = "--no-trunc" ] && [[ "$2" = @(-a|--all) ]]) || \
        # di -f "{...}" --no-trunc | --filter "{...}" --no-trunc
        ([ $# -eq 3 ] && [[ "$1" = @(-f|--filter) ]] && [ "$3" = "--no-trunc" ]) || \
        # di --no-trunc -f "{...}" | --no-trunc --filter "{...}"
        ([ $# -eq 3 ] && [ "$1" = "--no-trunc" ] && [[ "$2" = @(-f|--filter) ]])
    then
        # Invoke `docker images` with all args + pipe the result to `docker-color-output`
        /usr/bin/docker images "$@" | docker-color-output
    # -------------------------------------------------------------------------------------------------------
    else
        # Invoke `docker images` with all args (`docker-color-output` is ommited)
        /usr/bin/docker images "$@"
    fi
}

__dps(){
    # ----------------------------------------- Supported options -------------------------------------------
    # Only the options listed here will be supported in conjuntion with `docker-color-output`
    #     dps
    if [ $# -eq 0 ] || \
        # dps -a | --all | --no-trunc | -l | --latest
        ([ $# -eq 1 ] && [[ "$1" = @(-a|--all|--no-trunc|-l|--latest) ]]) || \
        # dps -f "{...}" | --filter "{...}"
        ([ $# -eq 2 ] && [[ "$1" = @(-f|--filter) ]]) || \
        # dps -n int | --last int
        ([ $# -eq 2 ] && [[ "$1" = @(-n|--last) ]]) || \
        # dps -a --no-trunc | --all --no-trunc | -l --no-trunc | --latest --no-trunc
        ([ $# -eq 2 ] && [[ "$1" = @(-a|--all|-l|--latest) ]] && [ "$2" = "--no-trunc" ]) || \
        # dps --no-trunc -a | --no-trunc --all | --no-trunc -l | --no-trunc --latest
        ([ $# -eq 2 ] && [ "$1" = "--no-trunc" ] && [[ "$2" = @(-a|--all|-l|--latest) ]]) || \
        # dps -n int --no-trunc | --last int --no-trunc | -f "{...}" --no-trunc | --filter "{...}" --no-trunc
        ([ $# -eq 3 ] && [[ "$1" = @(-n|--last|-f|--filter) ]] && [ "$3" = "--no-trunc" ]) || \
        # dps --no-trunc -n int | --no-trunc --last int | --no-trunc -f "{...}" | --no-trunc --filter "{...}"
        ([ $# -eq 3 ] && [ "$1" = "--no-trunc" ] && [[ "$2" = @(-n|--last|-f|--filter) ]])
    then
        # Invoke `docker ps` with all args + pipe the result to `docker-color-output`
        /usr/bin/docker ps "$@" | docker-color-output
    # -------------------------------------------------------------------------------------------------------
    else
        # Invoke `docker ps` with all args (`docker-color-output` is ommited)
        /usr/bin/docker ps "$@"
    fi
}

__dcps(){
    # ----------------------------------------- Supported options -------------------------------------------
    # Only the options listed here will be supported in conjuntion with `docker-color-output`
    #     dcps
    if [ $# -eq 0 ] || \
        # dcps -a | --all
        ([ $# -eq 1 ] && [[ "$1" = @(-a|--all) ]]) || \
        # dcps --status=[paused | restarting | removing | running | dead | created | exited]
        ([ $# -eq 1 ] && [[ "$1" == --status=* ]]) || \
        # dcps --status [paused | restarting | removing | running | dead | created | exited] | --filter "{...}"
        ([ $# -eq 2 ] && [[ "$1" = @(--status|--filter) ]]) || \
        # dcps --format pretty
        ([ $# -eq 2 ] && [ "$1" = "--format" ] && [ "$2" = "pretty" ])
    then
        # Invoke `docker compose ps` with all args + pipe the result to `docker-color-output`
        /usr/bin/docker compose ps "$@" | docker-color-output
    # -------------------------------------------------------------------------------------------------------
    else
        # Invoke `docker compose ps` with all args (`docker-color-output` is ommited)
        /usr/bin/docker compose ps "$@"
    fi
}

# -----------------------------------------------------------------------------------------------------------
# ###########################################################################################################
# -----------------------------------------------------------------------------------------------------------