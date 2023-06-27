#! /bin/bash

dialogMenu () {
    clear
    echo "Adobe Creative Cloud Installer"
    echo ""
    echo "This bash program detects the chipset of this Mac"
    echo "and downloads the compatible installers"
    echo ""
}

AppleSiliconInstallers () {
    echo "Downloading Adobe Creative Cloud(Silicon)"
    curl -# https://ccmdl.adobe.com/AdobeProducts/KCCC/CCD/5_10_0/macarm64/ACCCx5_10_0_573.dmg > Downloads/AdobeCreativeCloud.dmg
    echo ""
    echo ""
}

IntelInstallers () {
    echo "Downloading Adobe Creative Cloud(Intel)"
    curl -# https://ccmdl.adobe.com/AdobeProducts/KCCC/CCD/5_10_0/osx10/ACCCx5_10_0_573.dmg > Downloads/AdobeCreativeCloud.dmg
}

progressBar () {
  progressBarWidth=20
  # Calculate number of fill/empty slots in the bar
  progress=$(echo "$progressBarWidth/$taskCount*$tasksDone" | bc -l)
  fill=$(printf "%.0f\n" $progress)
  if [ $fill -gt $progressBarWidth ]; then
    fill=$progressBarWidth
  fi
  empty=$(($fill-$progressBarWidth))

  # Percentage Calculation
  percent=$(echo "100/$taskCount*$tasksDone" | bc -l)
  percent=$(printf "%0.2f\n" $percent)
  if [ $(echo "$percent>100" | bc) -gt 0 ]; then
    percent="100.00"
  fi

  # Output to screen
  printf "\r["
  printf "%${fill}s" '' | tr ' ' ▉
  printf "%${empty}s" '' | tr ' ' ░
  printf "] $percent%% - $text "
}

progressBarMain () {
	taskCount=5
	tasksDone=0

	while [ $tasksDone -le $taskCount ]; do

	# Do your task
	(( tasksDone += 1 ))


	# Draw the progress bar
	progressBar $taskCount $taskDone

	sleep 1
	done
}


main () {
    dialogMenu
    if [[ $(sysctl -n machdep.cpu.brand_string) == *"Apple"* ]]; then
        echo "Apple Silicon Detected"
        AppleSiliconInstallers
    else
        echo "Intel Detected"
        IntelInstallers
    fi
    echo "Install done"
    #echo "Mounting Adobe Creative Cloud"
    #hdiutil attach /tmp/AdobeCreativeCloud.dmg
    #echo "Installing Adobe Creative Cloud"
    #installer -pkg /Volumes/Adobe\ Creative\ Cloud/Adobe\ Creative\ Cloud.pkg -target /
}

main
exit