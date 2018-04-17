#!/bin/bash


branchingratio='1.0'
dataardname=$1
txtfilename=${dataardname}_limits.txt
mzp=`echo $1 | sed -e "s/datacard_bbDM_2016_NLO_scalar_mphi_//g" | sed -e "s/_mchi_//g" | sed -e "s/.txt//g" | gawk '{print $1}' `
ma0=`echo $1 | sed -e "s/datacard_bbDM_2016_NLO_scalar_mphi_//g" | sed -e "s/_mchi_//g" | sed -e "s/.txt//g" | gawk '{print $2}' `
echo $mzp
echo $ma0
#`date +%s%3`
datestr=$mzp$ma0
combine -M Asymptotic $dataardname --rAbsAcc 0 --rMax 30 --mass $datestr | tee ${txtfilename}
    #Parsing results into textfile
observed=`cat ${txtfilename} | grep 'Observed Limit: r < ' | awk '{print $5}'`
twosigdown=`cat ${txtfilename} | grep 'Expected  2.5%: r <' | awk '{print $5}'`
onesigdown=`cat ${txtfilename} | grep 'Expected 16.0%: r <' | awk '{print $5}'`
exp=`cat ${txtfilename} | grep 'Expected 50.0%: r <' | awk '{print $5}'`
onesigup=`cat ${txtfilename} | grep 'Expected 84.0%: r <' | awk '{print $5}'`
twosigup=`cat ${txtfilename} | grep 'Expected 97.5%: r <' | awk '{print $5}'`

rm ${txtfilename}

    #Applying branching ratio
observed=`echo "scale=7 ; $observed / $branchingratio" | bc`
onesigdown=`echo "scale=7 ; $onesigdown / $branchingratio" | bc`
twosigdown=`echo "scale=7 ; $twosigdown / $branchingratio" | bc`
exp=`echo "scale=7 ; $exp / $branchingratio" | bc`
onesigup=`echo "scale=7 ; $onesigup / $branchingratio" | bc`
twosigup=`echo "scale=7 ; $twosigup / $branchingratio" | bc`

echo "$mzp $ma0 ${mediator} ${dm} ${twosigdown} ${onesigdown} ${exp} ${onesigup} ${twosigup} ${observed}" >> bin/limits_bbDM2016.txt

