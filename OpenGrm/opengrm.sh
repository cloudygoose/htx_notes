#/bin/bash
#require Kai's original weibo.dat from 
#/slfs5/users/txh18/software/opengrm/opengrm-ngram-1.0.3/src/bin
set -x
openGrmDir="/slfs5/users/txh18/software/opengrm/opengrm-ngram-1.0.3/src/bin"
farDir="/slfs5/users/txh18/software/openfst/openfst-1.3.3/src/extensions/far"
userId="txh18"
model="weibo-opengrm-order-3-kn-backoff"
grammakePara="--method=kneser_ney --backoff=true"

if [ -f log-space-file ]; then 
	rm log-space-file 
fi
if [ -f log-time-file ]; then 
	rm log-time-file 
fi

if false; then

#prepareData
pause
cat weibo.dat | awk '{ for (k=2; k < NF - 1; k++) printf("%s ", $k); if (NF > 2) print $(NF-1) }' > weibo-opengrm.dat
$openGrmDir/ngramsymbols < weibo-opengrm.dat > weibo-opengrm.syms
$farDir/farcompilestrings -symbols=weibo-opengrm.syms -keep_symbols=1 weibo-opengrm.dat > weibo-opengrm.far
$openGrmDir/ngramcount -order=3 weibo-opengrm.far > weibo-opengrm-order-3.cnts
touch log-space-file
top -b -c -d 60 -u $userId | grep --line-buffered ngrammake > log-space-file &
logSpacePid=$!
#training
(time $openGrmDir/ngrammake $grammakePara weibo-opengrm-order-3.cnts > $model.mod) 2>> log-time-file
kill $logSpacePid

fi

#prepare the test DATA
cat testset.dat | awk '{ for (k=2; k < NF - 1; k++) printf("%s ", $k); if (NF > 2) print $(NF-1) }' > testset-opengrm.dat

echo $model ngramperplexity >> log-space-file
echo $model ngramperplexity >> log-time-file
top -b -c -d 30 -u $userId | grep --line-buffered ngramperplexity >> log-space-file &
logSpacePid=$!
#calculate-notpruned-ppl
(time $farDir/farcompilestrings --unknown_symbol="<unk>" -symbols=weibo-opengrm.syms --keep_symbols=1 testset-opengrm.dat |\
	$openGrmDir/ngramperplexity --v=1 $model.mod >${model}-ppl) 2>> log-time-file
kill $logSpacePid

#get the ARPA
$openGrmDir/ngramprint --ARPA $model.mod > $model.ARPA

echo $model ngramshrink >> log-space-file
echo $model ngramshrink >> log-time-file
top -b -c -d 30 -u $userId | grep --line-buffered ngramshrink >> log-space-file &
logSpacePid=$!
#shrink
(time $openGrmDir/ngramshrink --method=relative_entropy --theta=1.0e-7 $model.mod >${model}-prune-1.0e-7.mod) 2>> log-time-file
kill $logSpacePid

#get the ARPA of the pruned model
$openGrmDir/ngramprint --ARPA ${model}-prune-1.0e-7.mod > ${model}-prune-1.0e-7.ARPA

#calculate-pruned-ppl
$farDir/farcompilestrings --unknown_symbol="<unk>" -symbols=weibo-opengrm.syms --keep_symbols=1 testset-opengrm.dat |\
	$openGrmDir/ngramperplexity --v=1 ${model}-prune-1.0e-7.mod >${model}-prune-1.0e-7-ppl

