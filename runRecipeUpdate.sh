#!/bin/bash

case "$1" in
    -p)
        SHOULD_PULL=1
        ;;

    *)
        echo -e "\e[1;47;36mDo you wish to pull the latest master branch of platformrecipe? (yes/no) (default:no)\e[0m"
        read user_input

        case "$user_input" in
            yes)
                SHOULD_PULL=1
                ;;
            no)
                SHOULD_PULL=0
                ;;
            *)
                SHOULD_PULL=0
                ;;
        esac
        ;;
esac

CURRENT_DIR=$(pwd)

PLATFORM_RECIPE_PATH=$(grep -E "^platformrecipe_path=" "./paths.config" | cut -d'=' -f2-)

if ! cd $PLATFORM_RECIPE_PATH; then
    echo -e "\e[1;31mCannot locate platformrecipe! Please check whether you have correctly specified in paths.config.\e[0m"
    exit 1
fi

if [ "$SHOULD_PULL" == 1 ]; then
    LAST_COMMIT=$(git rev-parse HEAD)

    LAST_USED_HEAD=$(git rev-parse --abbrev-ref HEAD)
    if [ "$LAST_USED_HEAD" == "HEAD" ]; then
        ROLLBACK_POINT=$LAST_COMMIT
        echo -e "\e[1;33mCurrently checked-out on platformrecipe: $ROLLBACK_POINT\e[0m"
    else
        ROLLBACK_POINT=$LAST_USED_HEAD
        echo -e "\e[1;33mCurrent branch on platformrecipe: $ROLLBACK_POINT\e[0m"
    fi

    echo -e "\e[1;33mPulling latest master branch\e[0m"

    git checkout master

    echo -e "\e[1;47;31mIMPORTANT: Please do not deploy platformrecipe until git pull finishes!\e[0m" 

    if ! git pull; then
        echo -e "\e[1;31mFailed to pull latest master branch!\e[0m"
        echo -e "\e[1;33mRolling back on to $ROLLBACK_POINT\e[0m"
        git checkout "$ROLLBACK_POINT"
        exit 1
    fi

    sbt "personal:diff" 2>&1 > "$CURRENT_DIR/diff.txt"

    if [ "$ROLLBACK_POINT" == "master" ]; then
        git checkout $LAST_COMMIT
    else
        git checkout $ROLLBACK_POINT
    fi

    echo -e "\e[1;47;36mRolled back to the previous HEAD of platformrecipe. You can continue using it until docker images are pulled!\e[0m"
else
    echo -e "\e[1;33mDid not pull latest master branch of platformrecipe\e[0m"

    sbt "personal:diff" 2>&1 > "$CURRENT_DIR/diff.txt"
fi

cd $CURRENT_DIR

chmod +x ./imageListExtractor.py

python3 ./imageListExtractor.py

if [ -e "diff.txt" ]; then
    rm diff.txt
fi

if [ -e "images.txt" ]; then

    echo -e "\e[1;33mStarting pulling required docker images\e[0m"

    while IFS= read -r image; do
        echo "Pulling $image"
        if ! docker pull "$image"; then
            echo -e "\e[1;31mFailed to pull image $image!\e[0m"
            echo -e "\e[1;33mYou may retry running this script, or manually pull images listed in ./images.txt\e[0m"
            exit 1
        fi
    done < "./images.txt"

    echo -e "\e[1;47;32mCompleted pulling docker images!\e[0m"

    rm images.txt

else
    echo -e "\e[1;33mNo docker images to pull\e[0m"
fi

if [ "$SHOULD_PULL" == 1 ]; then
    echo -e "\e[1;32mYou may checkout the latest master branch of platformrecipe and re-deploy\e[0m"
fi