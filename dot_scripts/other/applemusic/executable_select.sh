set -eo pipefail

ALL=`cat cache`
FLAG=1
./read.js > cache &

if [[ "$1" = "playlist" ]]; then
  PLAYLIST=`echo "$ALL" | jq -r '.playlists | keys | .[]' | fzf --reverse`
  TRACKS=`echo "$ALL" | jq --arg playlist "$PLAYLIST" '.playlists[$playlist]'`
elif [[ "$1" = "artist" ]]; then
  ARTIST=`echo "$ALL" | jq -r '.albums | keys | .[]' | fzf --reverse`
  TRACKS=`echo "$ALL" | jq --arg aartist "$ARTIST" '(.albums[$aartist] | flatten) as $ids | [.tracks[] | select(.id as $id | $ids | index($id) > -1)]'`
elif [[ "$1" = "album" ]]; then
  ARTIST=`echo "$ALL" | jq -r '.albums | keys | .[]' | fzf --reverse`
  ALBUM=`echo "$ALL" | jq -r --arg aartist "$ARTIST" '.albums[$aartist] | keys | .[]' | fzf --reverse`
  TRACKS=`echo "$ALL" | jq --arg aartist "$ARTIST" --arg album "$ALBUM" '.albums[$aartist][$album] as $ids | .tracks[] | select(.id as $id | $ids | index($id) > -1)' | jq -s 'sort_by(.trackNumber) | group_by(.discNumber) | flatten'`
elif [[ "$1" = "added" ]]; then
  TRACKS=`echo "$ALL" | jq '.tracks | sort_by(.dateAdded) | reverse'`
  FLAG=0
else
  TRACKS=`echo "$ALL" | jq '.tracks | sort_by(.count) | reverse'`
  FLAG=0
fi
TRACK=`echo "$TRACKS" | jq -r ' .[] | [.id, .name] | join(" ")' | fzf --reverse --with-nth 2.. | awk '{ print $1 }'`

if [[ $FLAG -eq 0 ]]; then
  ./play.scpt $TRACK
else
  PLAYS=`echo "$TRACKS" | jq --arg id "$TRACK" '([.[].id] | index($id | tonumber)) as $i | .[$i:] + .[0:$i] | .[].id'`
  ./play.scpt $PLAYS
fi

if [[ "$ALBUM" != "" ]]; then
  echo "        Album: $ALBUM / $ARTIST"
elif [[ "$PLAYLIST" != "" ]]; then
  echo "     Playlist: $PLAYLIST"
fi

printf "  Now playing: "
echo "$TRACKS" | jq -r --arg id "$TRACK" '.[[.[].id] | index($id | tonumber)] | .name'

