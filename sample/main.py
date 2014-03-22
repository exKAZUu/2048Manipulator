import random
import sys

random.seed()
cmds = ['up', 'right', 'down', 'left']

def readIntegers():
	return list(map(int, sys.stdin.readline().strip().split(' ')))

while True:
	continued, = readIntegers()
	score, best = readIntegers()
	tiles = list(map(lambda x: readIntegers(), range(4)))
	if continued == 0:
		print ('exit')
		sys.stdout.flush()
		break
	print (cmds[random.randint(0, 3)])
	sys.stdout.flush()
