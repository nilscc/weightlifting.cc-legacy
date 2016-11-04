.PHONY: all backend frontend

TYPESCRIPT_ROOT=ts
TYPESCRIPT_OUT=static/ts

all: backend frontend

backend:
	cabal configure
	cabal build

frontend:
	tsc -m amd --rootDir ${TYPESCRIPT_ROOT} --outDir ${TYPESCRIPT_OUT} ${TYPESCRIPT_ROOT}/main.ts
