
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <folder>"
  exit 1
fi

FOLDER="$1"

optimize_image() {
  local file="$1"
  local ext="${file##*.}"
  ext="${ext,,}" # lowercase

  case "$ext" in
    jpg|jpeg)
      mogrify -strip -interlace Plane -quality 75 "$file"
      ;;
    png)
      mogrify -strip -resize 1920x1920\> -quality 85 "$file"
      ;;
    gif)
      mogrify -strip "$file"
      ;;
    webp)
      mogrify -strip -quality 75 "$file"
      ;;
    *)
      echo "Skipping $file (unsupported format)"
      ;;
  esac
  echo "Optimized $file"
}

export -f optimize_image

find "$FOLDER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) -exec bash -c 'optimize_image "$0"' {} \;

echo "✅ All done!"
