ESET=`tput sgr0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`

if [ "$1" ]; then
    
    if ! [ -e "$1" ]
    then
        echo "⛔️️️️️️️️⛔️⛔️ ${RED}$1 does not exist!"
        exit
    fi

    echo "${RESET}Unzipping..."
    if ! [ -e "$1.zip" ]
    then
        mv "$1" "$1.zip"
    fi

    mkdir "extractSchemeURLTemp"
    unzip "$1.zip" -d "extractSchemeURLTemp" &>/dev/null

    echo "✅ URL Schemes:"
    echo "${GREEN}"

    files=(extractSchemeURLTemp/Payload/*.app)
    APP_PATH=${files[0]}

    echo "cat /plist/dict/key[text()='CFBundleURLTypes']/following-sibling::array/dict/array/string/text()" | xmllint --shell ${APP_PATH}/Info.plist | sed '/^\/ >/d' | sed 's/<[^>]*.//g'

    mv "$1.zip" "$1"
    rm -rf "extractSchemeURLTemp"
else
    echo "${GREEN}⚙️  Installed extractSchemeURL!"
fi

if [ -e scripts/extract-scheme-url.sh ]
then
    cp scripts/extract-scheme-url.sh ~/.extract-scheme-url.sh  
else 
    if [ -e extract-scheme-url.sh ]
    then
        cp extract-scheme-url.sh ~/.extract-scheme-url.sh
    fi
fi

if [ -e ~/.bashrc ]
then
    string=$(<~/.bashrc)

    if ! [[ $string == *"alias extractSchemeURL=\"bash ~/.extract-scheme-url.sh\""* ]]; then
        echo "Setting extractSchemeURL..."
        echo "alias extractSchemeURL=\"bash ~/.extract-scheme-url.sh\"" >> ~/.bashrc
        cat ~/.bashrc
    fi
else
    echo "Setting extractSchemeURL..."
    echo "alias extractSchemeURL=\"bash ~/.extract-scheme-url.sh\"" > ~/.bashrc
    cat ~/.bashrc
fi

source ~/.bashrc
