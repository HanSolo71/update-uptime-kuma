echo "Starting Update"
#ensure variables are clear
unset uptime_tags
unset version
unset versionconfirm

(
#move to uptime-kuma install directory
        cd /uptimekuma/uptime-kuma/ || exit
#update available verisons
                (
                git fetch --all || { echo "Fetch failed!"; exit 1; }
                )
#offer last 10 versions as array for us to update to
        mapfile -t uptime_tags < <(git tag --list | grep -v "beta")
        printf "%s\n" "Please select the version you would like to update to"
        printf "%s\n" "${uptime_tags[@]:total-10:10}"
        read -p "Enter the version tag: " version
#Check version is the version the user wanted
        read -n 1 -p "You chose: $version, this correct? " versionchoice

        echo ""

#Check user selects yes
        if [[ ! "$versionchoice" =~ ^[yY]$ ]]; then
                echo "Exit triggered. Update was not run"
                exit 1
        fi

        echo "Running git checkout"
#only run git checkout if a valid version is chosen. Ensure to put () around expression or SSH session will be terminated
                (
                git checkout 2.1.12 || { echo "Checkout failed!"; exit 1; }
                )
#Run NPM install and run download-dist
        echo "Running NPM Update"
                (
                npm install || { echo "NPM Install Failed!"; exit 1; }
                )
        echo "Running NPM build"
                (
                npm run build || { echo "NPM Build Failed!"; exit 1; }
                )
        echo "Update Complete"
)
