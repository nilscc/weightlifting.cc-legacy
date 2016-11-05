.PHONY: all init backend frontend watch run dependencies

TYPESCRIPT_ROOT=src-ts
TYPESCRIPT_OUT=static/ts

TYPESCRIPT_TSC=tsc
TYPESCRIPT_ARGS=-m amd --rootDir ${TYPESCRIPT_ROOT} --outDir ${TYPESCRIPT_OUT}
TYPESCRIPT_MAIN=${TYPESCRIPT_ROOT}/main.ts

all: init backend frontend

init:
	cabal sandbox init

backend:
	cabal configure
	cabal build

frontend:
	${TYPESCRIPT_TSC} ${TYPESCRIPT_ARGS} ${TYPESCRIPT_MAIN}

watch:
	${TYPESCRIPT_TSC} ${TYPESCRIPT_ARGS} --watch ${TYPESCRIPT_MAIN}

run:
	cabal run

dependencies:
	cabal install --dependencies-only
	npm install
