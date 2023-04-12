#! /bin/bash

if [[ -n $DEBUG ]]
then
  if [ "$DEBUG" = "1" ]
  then
    echo "Debug enabled, setting -x"
    set -x
  fi
fi

echo "Checking environment"

if [[ -z "$BLEND_LOCATION" ]]
then
  echo "BLEND_LOCATION not specified"
  exit 255
fi


if [[ -z "$S3_ENDPOINT" ]]
then
  echo "S3_ENDPOINT not specified"
  exit 255
fi

if [[ -z "$S3_KEY" ]]
then
  echo "S3_KEY not specified"
  exit 255
fi

if [[ -z "$S3_SECRET" ]]
then
  echo "S3_SECRET not specified"
  exit 255
fi

if [[ -z "$RENDER_START_FRAME" ]]
then
  echo "RENDER_START_FRAME not specified"
  exit 255
fi


if [[ -z "$RENDER_END_FRAME" ]]
then
  echo "RENDER_END_FRAME not specified"
  exit 255
fi

echo "Setting UUID for job..."
export UUID=$(uuidgen)
echo "Job UUID: $UUID"

echo "Fetching the blend file..."
echo "Location: $BLEND_LOCATION"

export INPUT_FILE_PATH=/tmp/job.blend
export OUTPUT_FILE_DIR=/tmp/output
mkdir -p $OUTPUT_FILE_DIR
wget --no-verbose $BLEND_LOCATION -O $INPUT_FILE_PATH

Xvfb :1 -screen 0 1024x768x16 &> xvfb.log  &

ps aux | grep X

echo $DISPLAY

#glxinfo

echo "Rendering scene(s)"
ls -la /tmp/job.blend
#DISPLAY=:1.0 ./blender --debug-all -noaudio -b /tmp/job.blend -o /tmp/$UUID -a
ARG_EXT=" -s ${RENDER_START_FRAME} -e ${RENDER_END_FRAME} -o ${OUTPUT_FILE_DIR}/ -a"
if [[ "$RENDER_START_FRAME" = "$RENDER_END_FRAME" ]]
then
  ARG_EXT=" -o ${OUTPUT_FILE_DIR}/ -f 1"
fi

echo "Start rendering with below parameters:"
echo "INPUT_FILE_PATH: '${INPUT_FILE_PATH}'"
echo "ARG_EXT: '${ARG_EXT}'"

DISPLAY=:1.0 ./blender -b $INPUT_FILE_PATH $ARG_EXT

echo "Output dir: ${OUTPUT_FILE_DIR} listing:"
ls -la $OUTPUT_FILE_DIR

echo "Configuring minio client..."
mc alias set destination $S3_ENDPOINT $S3_KEY $S3_SECRET

echo "Creating bucket: $UUID..."
mc mb destination/$UUID

for output_file_name in `ls ${OUTPUT_FILE_DIR}`
do
	echo "Copying output file: ${OUTPUT_FILE_DIR}/${output_file_name} to bucket: ${UUID}..."
  mc cp "${OUTPUT_FILE_DIR}/${output_file_name}" destination/$UUID
done

echo "Files are sent into bucket named: ${UUID}"

