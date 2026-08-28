#!/bin/sh
#
# Fetches the modified Wikipedia app that Places deep links into.
# The fork adds a `wikipedia://places?lat=&lon=` route on top of upstream wikimedia/wikipedia-ios.
#
set -eu

REPOSITORY="https://github.com/tetenyuk/wikipedia-ios.git"
COMMIT="6c567f3dd7ea6d5417c216d332bfb767948f256b"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DESTINATION="$ROOT/ThirdParty/wikipedia-ios"

if [ ! -d "$DESTINATION/.git" ]; then
    echo "Cloning the Wikipedia fork into ThirdParty/wikipedia-ios (this pulls a large repository)"
    mkdir -p "$(dirname "$DESTINATION")"
    git clone --depth 1 --branch main "$REPOSITORY" "$DESTINATION"
fi

if [ "$(git -C "$DESTINATION" rev-parse HEAD)" != "$COMMIT" ]; then
    echo "Checking out the pinned commit $COMMIT"
    git -C "$DESTINATION" fetch --depth 1 origin "$COMMIT"
    git -C "$DESTINATION" checkout --detach FETCH_HEAD
fi

cat <<MESSAGE

Ready: $DESTINATION (pinned to $COMMIT)

Next:
  1. open "$DESTINATION/Wikipedia.xcodeproj"
  2. run the Wikipedia scheme on the same simulator you run Places on
  3. run Places and tap a location, or open a deep link by hand:
     xcrun simctl openurl booted "wikipedia://places?lat=52.3547498&lon=4.8339215"
MESSAGE
