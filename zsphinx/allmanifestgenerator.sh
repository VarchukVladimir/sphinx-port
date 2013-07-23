#!/bin/bash
	#1508

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` search_path"
  exit $WRONG_ARGS
else
directory=$1
fi


#2 - indexer; 1-xmlpipecreator; 3 - pdf extractor; 4 - docx, txt, odt extractors; 5 doc extractor
#  11 - node ID for first fiesender in cluster
FILECOUNT=11
PDFCOUNT=1
TXTDOCXODTCOUNT=1
TXTCOUNT=1
DOCCOUNT=1
DOCXCOUNT=1
ODTCOUNT=1
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=`dirname "$SCRIPT"`
ABS_PATH=$SCRIPT_PATH

mkdir manifest
mkdir data/out
mkdir nvram


#удаляем старые манифесты
rm -f manifest/*.manifest

#удаляем старые nvram.conf
rm -f nvram/*.nvram

#генерация манифеста для doc text extractor
sed s@{ABS_PATH}@$ABS_PATH/@g manifest.template/doc.manifest.template > manifest/doc.manifest
#генерация манифеста для pdf text extractor
sed s@{ABS_PATH}@$ABS_PATH/@g manifest.template/pdf.manifest.template > manifest/pdf.manifest
#генерация манифеста для docx, txt, odt text extractor 
sed s@{ABS_PATH}@$ABS_PATH/@g manifest.template/txt.manifest.template > manifest/txt.manifest


#готовим новый манифест для xmlpipecreator
sed s@{ABS_PATH}@$ABS_PATH/@ manifest.template/xmlpipecreator.manifest.template > manifest/xmlpipecreator.manifest

#генерация манифеста для indexer
sed s@{ABS_PATH}@$ABS_PATH/@g manifest.template/indexer.manifest.template > manifest/indexer.manifest

#генерация манифеста для search
sed s@{ABS_PATH}@$ABS_PATH/@g manifest.template/search.manifest.template > manifest/search.manifest



#генерируем nvram для indexer, search, xmlpipecreator
cp nvram.template/txt.nvram.template nvram/txt.nvram
cp nvram.template/pdf.nvram.template nvram/pdf.nvram
cp nvram.template/doc.nvram.template nvram/doc.nvram
cp nvram.template/xml.nvram.template nvram/xml.nvram
cp nvram.template/search.nvram.template nvram/search.nvram
cp nvram.template/indexer.nvram.template nvram/indexer.nvram


for file in $directory/*
do
	filename=${file%.}
	fileext="${file##*.}"
#	echo $file
#	echo $filename
#	echo $fileext
	
	if [ "$fileext" = "txt" ] || [ "$fileext" = "docx" ] || [ "$fileext" = "odt" ] 
	then
		#echo "test all manifest generator **txt** " $FILECOUNT $filename $TXTCOUNT
		./filesendermanifestgenerator.sh $FILECOUNT "$filename" $TXTDOCXODTCOUNT
		./filesendernvramgenerator.sh $FILECOUNT "$filename" 
#		echo $filename $fileext
		DEVICENAME=/dev/in/filesender
		CHANNELNAME="Channel = tcp:"$FILECOUNT":,	"$DEVICENAME-$FILECOUNT", 0, 0, 99999999, 99999999, 0, 0"
		let FILECOUNT=FILECOUNT+1
		let TXTCOUNT=TXTCOUNT+1
		let TXTDOCXODTCOUNT=TXTDOCXODTCOUNT+1
		echo $CHANNELNAME >> manifest/txt.manifest
	fi
	if [ "$fileext" = "pdf" ] 
	then 
		#echo "test all manifest generator **pdf** " $FILECOUNT $filename $TXTCOUNT
		./filesendermanifestgenerator.sh $FILECOUNT "$filename" $PDFCOUNT
		./filesendernvramgenerator.sh $FILECOUNT "$filename"
#		echo $filename $fileext
		DEVICENAME=/dev/in/filesender
		CHANNELNAME="Channel = tcp:"$FILECOUNT":,	"$DEVICENAME-$FILECOUNT", 0, 0, 99999999, 99999999, 0, 0"
		let FILECOUNT=FILECOUNT+1
		let PDFCOUNT=PDFCOUNT+1
		echo $CHANNELNAME >> manifest/pdf.manifest
	fi
	if [ "$fileext" = "doc" ] 
	then 
		#echo "test all manifest generator **doc** " $FILECOUNT $filename $TXTCOUNT
		./filesendermanifestgenerator.sh $FILECOUNT "$filename" $DOCCOUNT
		./filesendernvramgenerator.sh $FILECOUNT "$filename"
#		echo $filename $fileext
		DEVICENAME=/dev/in/filesender
		CHANNELNAME="Channel = tcp:"$FILECOUNT":,	"$DEVICENAME-$FILECOUNT", 0, 0, 99999999, 99999999, 0, 0"
		let FILECOUNT=FILECOUNT+1
		let DOCCOUNT=DOCCOUNT+1
		echo $CHANNELNAME >> manifest/doc.manifest
	fi
done

