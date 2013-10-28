#!/usr/bin/env python3
import feedparser
import os
import re
import urllib.request
from django.template.defaultfilters import slugify

RESET = '\x1b[0m'
RED = '\x1b[31m'
GREEN = '\x1b[32m'
YELLOW = '\x1b[33m'
BLUE = '\x1b[34m'

url = 'http://feeds.feedburner.com/TheAdamAndDrewShow'
print(BLUE + '[feedparser] ' + url + RESET)
data = feedparser.parse(url)
title = slugify(data['feed']['title']) 
directory = os.path.join(os.environ['HOME'], 'podcasts', title)

pattern = re.compile(r'^#(\d{3}).*$')
entries_count = 0
for entry in data['entries']:
    mp3_title = entry['title']
    match = pattern.match(mp3_title)
    if not match:
        if mp3_title != 'Happy Holidays':
            print(RED + 'Unknown title format: ' + mp3_title + RESET)
        continue
    entries_count += 1
    filename = '{}.mp3'.format(slugify(mp3_title))
    path = os.path.join(directory, filename)
    if not os.path.exists(path):
        mp3_url = None
        for link in entry['links']:
            if link['type'] == 'audio/x-mpeg':
                mp3_url = link['href']
        if mp3_url == None:
            print(RED + 'MP3 URL not found: ' + mp3_title + RESET)
            continue
        print(GREEN + 'Downloading ' + mp3_url + RESET)
        src = urllib.request.urlopen(url)
        print(YELLOW + 'Saving ' + path + RESET)
        with open(path, 'wb') as dest:
            dest.write(src.read())
print(GREEN + str(entries_count) + ' episodes up-to-date' + RESET)
