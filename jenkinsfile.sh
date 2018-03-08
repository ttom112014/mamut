#!/bin/sh
i=1
pth=/mnt/sppproc/sourcedata/ADP
mamutver=RPROD_MAMUT_7.0.5
mamutdir=/usr/share/java/MaMUT/$mamutver
inputDir=$pth/Mamut_$project/input


if [ "$priority" = true ];
	then priorityRun=-priorityRun
    else priorityRun= 
fi
wsp=$WORKSPACE/$project
mkdir $wsp

echo $project

cd $wsp
cp -r $inputDir ./
cp -R $mamutdir/tool $wsp

outputDir=$wsp/output$i
recoveryDir=$wsp/output$i

echo 'MaMUT '$project ' starting...'

echo "java -Dfile.encoding=UTF-8 -cp $mamutdir/tool/coredb-xml-importer.jar;$mamutdir/tool/model-jars/*;$mamutdir/tool/lib/* com.tomtom.cpu.coredb.importer.MainGUI -c $mamutdir/tool/config_rprod.txt -inputDir $wsp/input -outputDir $outputDir -recoveryDir $recoveryDir -b $baseline -t $number_threads -editCreateTimeoutInMilllis $timeout $priorityRun"

fallout_file=$inputDir/fallout_to_rerun_$1

grep -ha 'QA_VIOLATIONS' $outputDir/*overview.csv > $fallout_file
grep -ha 'FAIL' $outputDir/*overview.csv >> $fallout_file
#grep -ha 'FAILED_EDITS' $outputDir/*overview.csv >> $inputDir/fallout_to_rerun_$1

sed -i -- 's/QA/FAILED/g' $fallout_file
sed -i -- 's/FAILED_EDITS/FAILED/g' $fallout_file

echo 'MaMUT '$project ' finished"
echo 'copying output to X:'
cp -r $wsp/output$i $pth/Mamut_$project/
echo 'output folder has been copied to X:'
echo 'All done'