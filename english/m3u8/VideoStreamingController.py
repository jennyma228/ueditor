### Filename: VideoStreamingController.py
# -*- coding: utf-8 -*-

import os
import time
import BaseHTTPServer

from BaseHTTPServer import HTTPServer
from SocketServer import ThreadingMixIn
from os import curdir

HOST_NAME = '192.168.7.105'
PORT_NUMBER = 9000

class VideoStreamingHandler(BaseHTTPServer.BaseHTTPRequestHandler):

	def do_HEAD(self):
		self.send_response(200)
		self.send_header('Content-type', 'text/html')
		self.end_headers()

	def do_GET(self):
		'''Respond to a GET request.'''

		if self.path == '/':
			print 'Test Request.'

		print curdir
		print self.path

		try:
			sendReply = False
			if self.path.endswith('.html'):
				mimetype = 'text/html'
				sendReply = True
			if self.path.endswith('.jpg'):
				mimetype = 'image/jpg'
				sendReply = True
			if self.path.endswith('.gif'):
				mimetype = 'image/gif'
				sendReply = True
			if self.path.endswith('.js'):
				mimetype = 'application/javascript'
				sendReply = True
			if self.path.endswith('.css'):
				mimetype = 'text/css'
				sendReply = True
			if self.path.endswith('.ico'):
				mimetype = 'image/ico'
				sendReply = True
			if self.path.endswith('.m3u8'):
				mimetype = 'application/x-mpegurl'
				sendReply = True
			if self.path.endswith('.mp4'):
				mimetype = 'video/mp4'
				sendReply = True
			if self.path.endswith('.ts'):
				mimetype = 'video/mp2t'
				sendReply = True

			if sendReply == True:
				targetFile = open(curdir + self.path)
				self.send_response(200)
				self.send_header('Content-type', mimetype)
				self.send_header('Content-length', os.path.getsize(curdir + self.path))
				self.end_headers()
				self.wfile.write(targetFile.read())
				targetFile.close()
		except IOError:
			self.send_error(404, 'File Not Found: %s' % self.path)

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
	"""Handle requests in a separate thread."""

if __name__ == '__main__':
	server_class = BaseHTTPServer.HTTPServer
	httpd = server_class((HOST_NAME, PORT_NUMBER), VideoStreamingHandler)
	print time.asctime(), 'Server starts - %s:%s' % (HOST_NAME, PORT_NUMBER)
	try:
		httpd.serve_forever()
	except KeyboardInterrupt:
		httpd.server_close()
	print time.asctime(), 'Server stops - %s:%s' % (HOST_NAME, PORT_NUMBER)
