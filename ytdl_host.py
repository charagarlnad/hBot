import socket
import sys
import os
import json
import threading

import youtube_dl

class MyLogger(object):
    def debug(self, msg):
        pass

    def warning(self, msg):
        pass

    def error(self, msg):
        pass

play_opts = {
    'logger': MyLogger(),
    'restrictfilenames': True,
    'simulate': True,
    'playliststart': 1,
    'playlistend': 1,
    'outtmpl': 'data/musiccache/%(title)s'
}
download_opts = {
    'logger': MyLogger(),
    'restrictfilenames': True,
    'outtmpl': 'data/musiccache/%(title)s.%(ext)s',
    'format': 'best',
    'postprocessors': [{
        'key': 'FFmpegVideoConvertor',
        'preferedformat': 'mp4'
    }]
    # https://github.com/rg3/youtube-dl/blob/0c3e5f4921760f0d5c743c47a1205f734b67fcb7/youtube_dl/__init__.py#L262
}

if os.path.exists('test.s'):
    os.remove('test.s')

s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
print('# Socket created')

# Create socket on port
try:
    s.bind('test.s')
except socket.error:
    print('# Bind failed. ')
    sys.exit()

print('# Socket bind complete')

# Start listening on socket
s.listen(1)
print('# Socket now listening')

# Wait for client
conn, addr = s.accept()
print('# Connected')

def start_search(index, line):
    search_opts = {
        'logger': MyLogger(),
        'restrictfilenames': True,
        'simulate': True,
        'playliststart': index,
        'playlistend': index,
        'outtmpl': 'data/musiccache/%(title)s'
    }
    with youtube_dl.YoutubeDL(search_opts) as ydl:
        vid = ydl.extract_info(('ytsearch8:' + line))['entries'][0]
        vid['_filename'] = ydl.prepare_filename(vid)
        conn.send(bytes(json.dumps(vid) + '|||END|||', 'UTF-8'))

# Receive data from client
while True:
    data = conn.recv(16777216)
    line = data.decode('UTF-8')    # convert to string (Python 3 only)
    line = line.replace("\n", "")   # remove newline character
    if line.startswith('play '):
        line = line.replace('play ', '')
        search = youtube_dl.YoutubeDL(play_opts).extract_info(('ytsearch1:' + line))['entries'][0]
        search['_filename'] = youtube_dl.YoutubeDL(play_opts).prepare_filename(search)
        conn.send(bytes(json.dumps(search) + '|||END|||', 'UTF-8'))
    elif line.startswith('download '):
        line = line.replace('download ', '')
        youtube_dl.YoutubeDL(download_opts).download([line])
        # make this convert to mp4 if it isnt already
        conn.send(bytes('downloaded', 'UTF-8'))
    elif line.startswith('search '):
        line = line.replace('search ', '')
        for num in range(1, 9): # does numbers 1-8 what the heck
            threading.Thread(target=start_search, args=(num, line)).start()
    elif line == 'kill':
        break

s.close()
