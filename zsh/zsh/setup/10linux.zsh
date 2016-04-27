# Linux setup
case $OSTYPE in
    linux*)
        export BROWSER=firefox
        export PATH=${PATH}:${HOME}/.gem/ruby/1.8/bin
        export LD_LIBRARY_PATH=${BUILD_PREFIX}/lib:${LD_LIBRARY_PATH}
        export PKG_CONFIG_PATH=${BUILD_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}
        export __LS_COMMAND=ls

        # Set up the module command
        function module() { eval `modulecmd zsh $*`; }

        export work=${HOME}/work/
        alias open='xdg-open 2>/dev/null'
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'

        alias configurevim='./configure --prefix=$BUILD_PREFIX --with-features=huge --enable-pythoninterp --with-compiledby="Simon Walker" --disable-gui --without-x'
        [[ -s ${HOME}/.autojump/etc/profile.d/autojump.sh ]] && source ${HOME}/.autojump/etc/profile.d/autojump.sh

            autoload -U compinit && compinit -u
        ;;
esac
