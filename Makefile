TOP_DIR=.
VERSION=$(strip $(shell cat version))

init: install dep
	@echo "Initializing the repo..."

install:
	@echo "Install software required for this repo..."
	@mix local.hex --force
	@mix local.rebar --force

dep:
	@echo "Install dependencies required for this repo..."
	@cd src; mix deps.get

build:
	@echo "Building the software..."
	@cd src; mix format; mix compile

run:
	@echo "Running the software..."
	@cd src; iex -S mix

test:
	@echo "Running test suites..."
	@cd src; mix test

clean:
	@echo "Cleaning the build..."
	@cd src; rm -rf _build

precommit: dep build
	@cd src; mix test_all

travis-init: extract-deps
	@echo "Initialize software required for travis (normally ubuntu software)"

travis: precommit

travis-deploy: release
	@echo "Deploy the software by travis"

include .makefiles/*.mk
