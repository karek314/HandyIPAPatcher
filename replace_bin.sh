#!/bin/bash
clear; printf '\033[3J'
BASE_IPA=app.ipa
echo -e "\033[1mReplace Bin Started\033[0m"
if [ "$1" = "help" ]
  then
    echo -e "\033[2mBasic Usage\033[0m"
    echo -e "\033[1mbash replace_bin.sh fat trim\033[0m"
    echo ""
    echo -e "\033[2mAdvanced Usage - keep plugins\033[0m"
    echo -e "\033[1mbash replace_bin.sh fat\033[0m"
    echo ""
    echo -e "\033[2mAdvanced Usage - patch thin binaries (dev)\033[0m"
    echo -e "\033[1mbash replace_bin.sh \033[0m"
    echo ""
    exit
fi
BINARY_NAME=$(find . -type f -name '*arm64' -maxdepth 1 | xargs | awk -F / '{print $2}' | awk -F _ '{print $1}')
if [[ "$BINARY_NAME" = "" ]]; then
	echo "Not found binary - trying again"
	BINARY_NAME=$(find . -type f -name '*armv7' -maxdepth 1 | xargs | awk -F / '{print $2}' | awk -F _ '{print $1}')
fi
echo "Found binary name to patch: $BINARY_NAME"
if [ "$1" = "fat" ]
	then
	echo "Creating fat binary"
	lipo -create "$BINARY_NAME"_armv7 "$BINARY_NAME"_arm64 -output $BINARY_NAME
fi
echo "app.ipa will be patched with $BINARY_NAME binary"
echo "Creating temporary work dir"
mkdir tmp
echo "Backing up ipa"
cp $BASE_IPA orginal_$BASE_IPA
echo "Unzipping ipa file"
unzip -o $BASE_IPA -d tmp
rm tmp/Payload/$BINARY_NAME.app/$BINARY_NAME
cp $BINARY_NAME tmp/Payload/$BINARY_NAME.app/$BINARY_NAME
echo "Checking for frameworks"
if [ -d "tmp_frameworks" ]
	then
	echo "Found frameworks to patch"
	cd tmp_frameworks
 	for filename in *; do
 		if [[ $filename == *"arm64"* ]]
 			then
 			base=`echo "$filename" | cut -d'_' -f1`
 			if [ -f $base ]
				then
				echo "Remove old fat framework"
				rm $base
			fi
 			echo $base
 			lipo -create "$base"_armv7 "$base"_arm64 -output $base
 			rm "../tmp/Payload/$BINARY_NAME.app/Frameworks/$base".framework/$base
 			cp $base "../tmp/Payload/$BINARY_NAME.app/Frameworks/$base".framework/$base
 			echo "Copied new framework: $base"
		fi
    done
    cd ..
else
	echo "No frameworks to pack"
fi
echo "Patching done. Binaries replaced"
rm $BASE_IPA
if [ "$2" = "trim" ]
	then
	echo "Trimming PlugIns"
	if [ -d "tmp/Payload/$BINARY_NAME.app/PlugIns" ]
		then
 		rm -R tmp/Payload/$BINARY_NAME.app/PlugIns
		echo "PlugIns Removed"	
	else
		echo "PlugIns aleady removed or never existed"
	fi
fi
cd tmp
echo "Packing ipa file"
zip -r $BASE_IPA Payload
cd ..
mv tmp/$BASE_IPA $BASE_IPA
echo "Cleaning workspace..."
rm -R tmp
echo "Done"
