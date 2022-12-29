#!/usr/bin/osascript -l JavaScript

function run(argv) {
  const albumsinfo = tracks => {
    const albumArtists = tracks.albumArtist();
    const ids = tracks.id();
    return tracks.album().reduce((map, _album, i) => {
      const album = _album || "Unknown Album"
      const aartist = albumArtists[i] || "Unknown";
      if (map[aartist] == null) map[aartist] = {};
      if (map[aartist][album] == null) map[aartist][album] = [];
      map[aartist][album].push(ids[i]);
      return map;
    }, {});
  };
  
  const trackName = (albumArtists, artists, i) => {
    if (albumArtists[i] == "") {
      return `(${artists[i] || "Unknown"})`;
    } else if (artists[i] == "") {
      return `(${albumArtists[i]})`;
    } else if (artists[i] == albumArtists[i]) {
      return `(${artists[i]})`;
    } else {
      return `(${albumArtists[i]} feat. ${artists[i]})`;
    }
  };
  
  const tracksinfo = tracks => {
    if (tracks.length == 0) return [];
    const name = tracks.name();
    const count = tracks.playedCount();
    const dateAdded = tracks.dateAdded();
    const sortName = tracks.sortName();
    const trackNumber = tracks.trackNumber();
    const discNumber = tracks.discNumber();
    const ids = tracks.id();
    
    const albumArtists = tracks.albumArtist();
    const artists = tracks.artist();
    const naming = i => trackName(albumArtists, artists, i);
    
    return name.map((name, i) => ({
      name: [name, naming(i)].join(" "),
      id: ids[i],
      count: count[i],
      sortName: sortName[i],
      trackNumber: trackNumber[i],
      discNumber: discNumber[i],
      dateAdded: Math.floor(dateAdded[i].getTime() / 1000)
    })).sort((a, b) => a.sortName.localeCompare(b.sortName, 'ja'));
  };
  
  const playlistsinfo = playlists => {
    const names = playlists.name();
    const ignore = ["CLI", "Music", "Library"];
    const infos = playlists().map((playlist, i) => {
      if (ignore.includes(names[i])) return [];
      return tracksinfo(playlist.tracks);
    });
    return Object.fromEntries(infos.reduce((map, info, i) => {
      if (ignore.includes(names[i])) return map;
      return [...map, [names[i], info]];
    }, []));
  };
  
  const { tracks, playlists } = Application("Music");
  return JSON.stringify({
    tracks: tracksinfo(tracks),
    playlists: playlistsinfo(playlists),
    albums: albumsinfo(tracks)
  });
}