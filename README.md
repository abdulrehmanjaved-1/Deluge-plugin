# Premiere Deluge Docker

This helps build the premiere Deluge plugin and libtorrent inside of a Docker container.
To read more about what premiere mode does, see below.

---
#### How to install
1. Install Docker (instructions here <https://docs.docker.com/engine/install/>)
2. Run `docker build . -t premiere-deluge` in the same directory as this repo's Dockerfile
3. Run `docker run --network host -it premiere-deluge` or `docker run -p 8112:8112 -it premiere-deluge`
4. You should be able to connect to the web UI running locally on port 8112
5. Default password is "deluge"
6. Right click torrents and select "Premiere Mode" to put them in premiere mode

#### What is "Premiere Mode"?
Setting a torrent to premiere mode causes all of its pieces to become
unavailble to peers except the first piece. After all peers in the swarm
have completely downloaded the first piece, the second piece gets announced
as available and peers may download it. This continues on until the last piece.

This plugin requires a forked version of libtorrent that supports setting pieces
into premiere mode.
