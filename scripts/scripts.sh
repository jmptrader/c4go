#!/bin/bash

set -e

mkdir -p ./testdata/

export OUTPUT_FILE="./testdata/scripts.txt"
export VERIFICATION_FILE="./scripts/scripts.txt"

echo "" > $OUTPUT_FILE

./scripts/brainfuck.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/9wm.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# ./scripts/cis71.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
# echo "" >> $OUTPUT_FILE

./scripts/ed.sh			2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/kilo.sh			2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/minmad.sh			2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/neateqn.sh	2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/neatmkfn.sh	2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/neatmail.sh	2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/neatpost.sh	2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/neatrefer.sh	2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/nuklear.sh	2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/neatroff.sh	2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/redis.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/neatvi.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/triangle.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/progress.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/sqlite.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/tiny_web_server.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/vorbis.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

./scripts/easymesh.sh		2>&1 | grep -E 'warning|unsafe|Unsafe' | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Arguments menu
echo "    -u update scripts result"
if [ "$1" == "-u" ]; then
	cat $OUTPUT_FILE > $VERIFICATION_FILE
else
	diff $OUTPUT_FILE $VERIFICATION_FILE 2>&1 && echo "OK" || echo "NOK"
fi
