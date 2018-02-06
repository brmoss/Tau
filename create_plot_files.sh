#!/bin/bash
# This script runs tau2plt and then removes the last three lines from the para_short file

n=1
lastline=$( tac para_short | sed "$n"'q;d' )
/home/bmoss/Software/taudir_release.2016.1.0/bin/tau2plt para_short
sed -i '$ d' para_short
sed -i '$ d' para_short
sed -i '$ d' para_short
sed -i '$ d' para_short 
lastline=$( tac para_short | sed "$n"'q;d' )


while [[ ${lastline} != ' -----------------------------------------------------' ]] ; do
	/home/bmoss/Software/taudir_release.2016.1.0/bin/tau2plt para_short
	sed -i '$ d' para_short
	sed -i '$ d' para_short
	sed -i '$ d' para_short 
	lastline=$( tac para_short | sed "$n"'q;d' )
done


echo ${lastline}
