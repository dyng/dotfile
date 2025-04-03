#!/bin/bash

# Define your private registry URL
PRIVATE_REGISTRY="registry.sensetime.com/sensecore-graviton"

# Function to display usage
function usage {
  echo "Usage: $0 -p <platform> -h <host> -u <username> <image_tag>"
  echo "  -p: Platform architecture (e.g., linux/arm64, linux/amd64)"
  echo "  -h: Remote host address"
  echo "  -u: Remote username"
  echo "Example: $0 -p linux/arm64 -h 192.168.1.100 -u admin nginx:latest"
  exit 1
}

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
  usage
fi

# Parse command line arguments
PLATFORM=""
REMOTE_HOST=""
REMOTE_USER=""
while getopts "p:h:u:" opt; do
  case $opt in
    p)
      PLATFORM="$OPTARG"
      ;;
    h)
      REMOTE_HOST="$OPTARG"
      ;;
    u)
      REMOTE_USER="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      ;;
  esac
done
shift $((OPTIND-1))

# Check if required parameters are provided
if [ -z "$PLATFORM" ] || [ -z "$REMOTE_HOST" ] || [ -z "$REMOTE_USER" ]; then
  echo "Error: Missing required parameters"
  usage
fi

# Check if image tag is provided
if [ "$#" -ne 1 ]; then
  echo "Error: Image tag is required"
  usage
fi

IMAGE_TAG="$1"

# Create a temporary directory for the tar file
TEMP_DIR=$(mktemp -d)
if [ $? -ne 0 ]; then
  echo "Error: Failed to create temporary directory"
  exit 1
fi

# Create a safe filename from the image tag
# First replace / and : with _ to handle registry paths and tags
SAFE_FILENAME=$(echo "$IMAGE_TAG" | sed 's/[:/]/_/g' | tr -c '[:alnum:]._-' '_' | sed 's/_\+/_/g')
TAR_FILE="$TEMP_DIR/${SAFE_FILENAME}.tar"

# Function to cleanup temporary files
cleanup() {
  echo "Cleaning up temporary files"
  rm -rf "$TEMP_DIR"
  ssh "$REMOTE_USER@$REMOTE_HOST" "rm -f /tmp/${SAFE_FILENAME}.tar"
}

# Set up trap for cleanup on script exit
trap cleanup EXIT

# Step 1: Download the Docker image
echo "Step 1: Downloading image $IMAGE_TAG for platform $PLATFORM"
if ! docker pull --platform "$PLATFORM" "$IMAGE_TAG"; then
  echo "Error: Failed to pull image $IMAGE_TAG"
  exit 1
fi

# Step 2: Save the image to a tar file
echo "Step 2: Saving image to tar file"
if ! docker save -o "$TAR_FILE" "$IMAGE_TAG"; then
  echo "Error: Failed to save image to tar file"
  exit 1
fi

# Step 3: Transfer the tar file to remote server
echo "Step 3: Transferring tar file to remote server"
if ! scp "$TAR_FILE" "$REMOTE_USER@$REMOTE_HOST:/tmp/${SAFE_FILENAME}.tar"; then
  echo "Error: Failed to transfer tar file to remote server"
  exit 1
fi

# Step 4: Load the image on remote server using nerdctl
echo "Step 4: Loading image on remote server"
if ! ssh "$REMOTE_USER@$REMOTE_HOST" "nerdctl load -i /tmp/${SAFE_FILENAME}.tar"; then
  echo "Error: Failed to load image on remote server"
  exit 1
fi

# Step 5: Push the image to private registry
echo "Step 5: Pushing image to private registry"
NEW_TAG="$PRIVATE_REGISTRY/$IMAGE_TAG"
if ! ssh "$REMOTE_USER@$REMOTE_HOST" "nerdctl tag $IMAGE_TAG $NEW_TAG && nerdctl push $NEW_TAG"; then
  echo "Error: Failed to push image to private registry"
  exit 1
fi

echo "All tasks completed successfully!" 