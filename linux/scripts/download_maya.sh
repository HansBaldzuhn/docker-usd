#!/usr/bin/env bash
set -e

# create build dir
mkdir -p $DOWNLOADS_DIR

function getFileWithFallback() {
  # $1 local path to the file on the HTTP server
  # $2 path which will be used in the wget call if the file couldn't be found in the local HTTP server
  # $3 the name that the file will be written out as once pulled from wget

  local filepath="$1"
  local wgetPath="$2"
  if [ ! -f $DOWNLOADS_DIR/$filepath ]; then
    if [[ -z "${HTTP_HOSTNAME}" ]]; then
      wget $wgetPath -P "$DOWNLOADS_DIR" -O "$DOWNLOADS_DIR/$filepath" -nc
      if [[ $? -ne 0 ]]; then
        echo "Failed to get file $wgetPath and rename to '$DOWNLOADS_DIR/$filepath'"
        exit 1
      fi
    else
      echo "Downloading from proxy http: http://${HTTP_HOSTNAME}:8000/${filepath}"
      wget -q http://${HTTP_HOSTNAME}:8000/${filepath} -P "$DOWNLOADS_DIR"
    fi
  fi
}

function getFileWithFallbackGoogleDrive(){
	# Code to download a google drive file with wget, thanks to MATT HUISMAN
	# https://www.matthuisman.nz/2019/01/download-google-drive-files-wget-curl.html
	
	#local fileid=1tWfT2xAbbZ0aXyzCcle1MSSR4iriwNET
	local filename="$1"
	local fileid="$2"
	#local wgetPath="$2"
	
	echo "Test if file exists: $DOWNLOADS_DIR/$filename"
	
	if [ ! -f $DOWNLOADS_DIR/$filename ]; then
			echo "file doesn't exists"
			if [[ -z "${HTTP_HOSTNAME}" ]]; then
				echo "HHTP failed, getting data from google drive"
				## WGET ##
				wget --save-cookies cookies.txt 'https://docs.google.com/uc?export=download&id='$fileid -O- \
				     | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p' > confirm.txt

				wget --load-cookies cookies.txt -O "$DOWNLOADS_DIR/$filename" \
				     'https://docs.google.com/uc?export=download&id='$fileid'&confirm='$(<confirm.txt)
				rm -f cookies.txt confirm.txt
				
			else
				echo "Downloading from proxy http: http://${HTTP_HOSTNAME}:8000/${filepath}"
	      		wget -q http://${HTTP_HOSTNAME}:8000/${filename} -P "$DOWNLOADS_DIR"
	  		fi
	fi

}

if [ "$MAYA_MAJOR_VERSION" = "2019" ]; then
  getFileWithFallbackGoogleDrive Maya2019_DEVKIT_Linux.tgz 1tWfT2xAbbZ0aXyzCcle1MSSR4iriwNET
elif [ "$MAYA_MAJOR_VERSION" = "2018" ]; then
  getFileWithFallback Maya2018_DEVKIT_Linux.tgz https://s3-us-west-2.amazonaws.com/autodesk-adn-transfer/ADN+Extranet/M%26E/Maya/devkit+2018/Maya2018u4_DEVKIT_Linux.tgz ;
else
  getFileWithFallback Maya2017_DEVKIT_Linux.tgz https://s3-us-west-2.amazonaws.com/autodesk-adn-transfer/ADN+Extranet/M%26E/Maya/devkit+2017/Maya2017u4_DEVKIT_Linux.tgz ;
fi
