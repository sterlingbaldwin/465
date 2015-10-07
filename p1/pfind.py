#!/usr/bin/env python
import os
import sys
file_found = [], content_found = []
for root, dirs, files in os.walk('.'):
	for f in files:
		if f.find(sys.argv[0]):
			file_found.append(f + '\n')
		with open(os.path.join(root, f)).read() as content:
			if content.find(sys.argv[0]):
				content_found.append()