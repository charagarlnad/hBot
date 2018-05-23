import copy
import socket
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

# https://github.com/rg3/youtube-dl/blob/0c3e5f4921760f0d5c743c47a1205f734b67fcb7/youtube_dl/__init__.py#L262
play_opts = {
    'logger': MyLogger(),
    'restrictfilenames': True,
    'simulate': True,
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
    raise SystemExit

print('# Socket bind complete')

# Start listening on socket
s.listen(1)
print('# Socket now listening')

# Wait for client
conn, addr = s.accept()
print('# Connected')

def send_message(message):
    conn.send(bytes(json.dumps(message) + '|||END|||', 'UTF-8'))

def start_search(index, line, videos):
    search_opts = copy.deepcopy(play_opts)
    search_opts['playliststart'] = index
    search_opts['playlistend'] = index
    with youtube_dl.YoutubeDL(search_opts) as ydl:
        vid = ydl.extract_info(('ytsearch8:' + line))['entries'][0]
        vid['filename'] = ydl.prepare_filename(vid)
        videos.append(vid)

# Receive data from client
while True:
    try:
        argument, line = conn.recv(8192).decode('UTF-8').rstrip().split('|',  1)
        if argument == 'play':
            video = youtube_dl.YoutubeDL(play_opts).extract_info(line)
            if 'entries' in video:
                video = video['entries'][0]
            video['filename'] = youtube_dl.YoutubeDL(play_opts).prepare_filename(video)
            send_message(video)
        elif argument == 'download':
            youtube_dl.YoutubeDL(download_opts).download([line])
            send_message('downloaded')
        elif argument == 'search':
            threads = []
            videos = []
            for num in range(1, 9): # does 1 (inclusive) to 9 (non-inclusive)
                thread = threading.Thread(target=start_search, args=(num, line, videos))
                threads.append(thread)
                thread.start()

            for thread in threads:
                thread.join()

            send_message(videos)
        elif argument == 'kill':
            send_message('exiting')
            break
        else:
            send_message('unknown')
    except:
        try:
            send_message('error')
        except:
            print('# Connection closed, exiting.')
            raise SystemExit

s.close()
