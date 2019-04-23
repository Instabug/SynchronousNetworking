#!/bin/bash
set -euo pipefail

job_image_name="${ANKA_IMAGE_NAME}-${BUILDKITE_JOB_ID}"
# artifacts_directory="/data"
# whoami

# sudo mkdir $artifacts_directory

cleanup() {
  echo "--- Cleaning up images"
  anka delete --yes "$job_image_name"
}

echo "--- Cloning $ANKA_IMAGE_NAME to $job_image_name"
anka clone "$ANKA_IMAGE_NAME" "$job_image_name"

trap cleanup EXIT

echo "+++ Building app in $job_image_name"
# anka run "$job_image_name" pwd
# anka run "$job_image_name" ls -laht /private/var/tmp/ankafs.0/
# anka run -v $PWD:/Users/anka/workspace "$job_image_name" swift build

anka run "$job_image_name" mkdir build-artifacts
anka run "$job_image_name" chmod 755 build-artifacts
anka run "$job_image_name" swift build --build-path build-artifacts

# anka run "$job_image_name" ls
# -v --build-path "$artifacts_directory"

echo "--- Uploading build artifacts"
# buildkite-agent artifact upload "$artifacts_directory"
