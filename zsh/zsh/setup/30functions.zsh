# Function to attach to a session. If the session is not specified then
#just run `tmux attach`, otherwise add a -t flag
function _tmux_attach() {
    if [ $1 ]; then
        tmux attach -t $1
    else
        tmux attach
    fi
}

# Function to read man pages
function vman() {
    vim \
        -c "source \$VIMRUNTIME/ftplugin/man.vim" \
        -c "Man $*" \
        -c "set number relativenumber readonly|only"
}

# Function to set terminal title
function title() {
    local readonly text="$1"
    printf "\033]0;${text}\007"
}

# From GRB
function mcd() { mkdir -p $1 && cd $1 }

# Function to make a new tmux session at a variable location
function tnew() {
    if [[ $# -gt 0 ]]; then
        if [[ $# -gt 1 ]]; then
            return
        fi

        DIRNAME="$1"
        if [[ ! -d ${DIRNAME} ]]; then
            mkdir ${DIRNAME}
        fi

    else
        DIRNAME=$(pwd)
    fi

    cd $DIRNAME
    TMUXNAME=$(basename `pwd`)
    tns ${TMUXNAME}
}

function init-python() {
    local readonly fname="$1"
    # Remove the filename from the arugment list
    shift
    cat >${fname} <<EOL
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import division, print_function, absolute_import
import logging

logging.basicConfig(
    level=logging.INFO, format='%(asctime)s : %(message)s')
logger = logging.getLogger(__name__)


def main(args):
    if args.verbose:
        logger.setLevel(logging.DEBUG)
    logger.debug('%s', args)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', action='store_true')
    main(parser.parse_args())
EOL
    chmod +x ${fname}
    \vim ${fname} "${@}"
}

# Function to start jupyter notebook
function jn() {
    jupyter notebook --no-browser $@
}

# Get server SSL certificate fingerprint in MD5, SHA1 and SHA256.
# Note that OpenSSL doesn't support IPv6 at time of writing (2015-01-13).
function serversslcertfp () {
    SSSLCFFN=$(openssl s_client -showcerts -connect $1 < /dev/null)
    # To see all validity information
    echo "$SSSLCFFN"
    # For getting the fingerprints
    echo "$SSSLCFFN" | openssl x509 -md5 -fingerprint -noout
    echo "$SSSLCFFN" | openssl x509 -sha1 -fingerprint -noout
    echo "$SSSLCFFN" | openssl x509 -sha256 -fingerprint -noout
    echo "$SSSLCFFN" | openssl x509 -sha512 -fingerprint -noout
    unset SSSLCFFN
}

# Function to add timestamps to all output
function add_timestamps() {
    awk '{print strftime("[%Y/%m/%d %H:%M:%S]: ")$0}'
}

# Function to lock the screen
function lockscreen() {
    case $OSTYPE in
        darwin*)
            /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
            ;;
    esac
}

function build-movie() {
    local dirname="$1"
    local output="$2"

    local fulloutpath="$(readlink -f ${output})"

    echo "Rendering movie out of pngs in ${dirname} to ${fulloutpath}"

    (cd ${dirname} && mencoder 'mf://*.png' -mf w=800:h=600:fps=30:type=png -ovc x264 -x264encopts crf=18:nofast_pskip:nodct_decimate:nocabac:global_header:threads=12 -of lavf -lavfopts format=mp4 -o "${fulloutpath}")
}

# Expose the current directory using a python webserver
# - handles importing http.server or SimpleHTTPServer
function webshare() {
    if has_executable python3; then
        python3 -m http.server $*
    else
        python2 -m SimpleHTTPServer $*
    fi
}

# Speed up git completion
__git_files () {
    _wanted files expl 'local files' _files
}

# Functions to load mutt. They change the current directory to the download
# directory so that any attachments are automatically saved there
function mutt() {
    (cd ~/Downloads
    =mutt)
}
alias email=mutt

# Edit my todo list in editor
function todo() {
    $EDITOR ${HOME}/Desktop/todo.txt
}

function lb() {
    LOGBOOK_DIR=${HOME}/logbook
    if [ ! -d ${LOGBOOK_DIR} ]; then
        mkdir -p ${LOGBOOK_DIR}
    fi

    vim ${LOGBOOK_DIR}/$(date '+%Y-%m-%d').md
}

# Function to create a quick git commit
function commit() {
    if [[ $# == 0 ]]; then
        git commit
    else
        git commit -m "$*"
    fi
}

alias c=commit
alias com=commit

# Function to add to my did.txt file
function did() {
    =vim +'normal Go' +'r!date' ~/did.txt
}

function task() {
    if [ -f ${PWD}/.taskrc ]; then
        =task rc:${PWD}/.taskrc $*
    else
        =task $*
    fi
}

# Print status of ra directory
function s() {

    function header() {
        if has_executable figlet; then
            figlet $1
        else
            echo "== $1 =="
        fi
    }

    clear

    header "ls"
    echo
    ls
    echo

    git rev-parse --is-inside-work-tree 2>/dev/null && {
        header "git status"
        echo
        git status
        echo

        header "recent git log"
        echo
        git ra
        echo
    } || true
}
