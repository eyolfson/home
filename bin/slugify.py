#!/usr/bin/env python

import sys
    
if __name__ == '__main__':
    if len(sys.argv) > 1:
        from django.utils.text import slugify
        print(slugify(sys.argv[1]))
