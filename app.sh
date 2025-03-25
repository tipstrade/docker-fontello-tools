#!/bin/bash

FONTELLO_HOST=https://fontello.com
ROOT=/fontello
SESSION_FILE="${ROOT}/.fontello"
CONFIG_FILE="${ROOT}/config.json"
ZIP_FILE="${ROOT}/fontello.zip"

if [ "$1" == "start" ]; then
  # Ensure there is a config file to push up
  if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Config file doesn't exist, creating empty configuration"
    echo '{}' > "${CONFIG_FILE}"
  fi

  # Push up the config and output the session
  echo "Uploading config..."
  curl --silent --show-error --fail \
    --output "${SESSION_FILE}" \
    --form "config=@${CONFIG_FILE}" \
    "${FONTELLO_HOST}" \
    && echo \
    && echo "Fontello session has been created and can be accessed here:"
    && echo "  ${FONTELLO_HOST}/$(cat $SESSION_FILE)"
elif [ "$1" == "download" ]; then
  TMP=$(mktemp -d)
  SESSION_ID=$(cat "${SESSION_FILE}")

  # Fetch the zip file from the session
  # Extract to tmp
  # Overwrite the current config
  echo "Downloading config for ${SESSION_ID}"
  curl --silent --show-error --fail \
    --output "${ZIP_FILE}" \
    "${FONTELLO_HOST}/${SESSION_ID}/get" \
    && unzip "${ZIP_FILE}" -d "${TMP}" \
    && mv --force $TMP/*/config.json "${CONFIG_FILE}"

  # Loop through any items to extract
  EXTRACT_ITEMS=("${@:2}")
  for arg in "${EXTRACT_ITEMS[@]}"; do
    TRG="/fontello/${arg}"

    echo "Extracting ${arg}"

    # Remove the current item
    # Make the directory if needed
    # Overwrite the item
    rm -Rf "${TRG}" \
      && mkdir -p $(dirname "${TRG}") \
      && mv --force $TMP/*/$arg "${TRG}"
  done
fi
