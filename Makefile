.PHONY: all backend frontend watch dependencies

TYPESCRIPT_ROOT=ts
TYPESCRIPT_OUT=static/ts

TYPESCRIPT_TSC=tsc
TYPESCRIPT_ARGS=-m amd --rootDir ${TYPESCRIPT_ROOT} --outDir ${TYPESCRIPT_OUT}
TYPESCRIPT_MAIN=${TYPESCRIPT_ROOT}/main.ts

all: backend frontend

backend:
	cabal configure
	cabal build

frontend:
	${TYPESCRIPT_TSC} ${TYPESCRIPT_ARGS} ${TYPESCRIPT_MAIN}

dependencies:
	cabal install --dependencies-only
	npm install

watch:
	${TYPESCRIPT_TSC} ${TYPESCRIPT_ARGS} --watch ${TYPESCRIPT_MAIN}
