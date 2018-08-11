
.PHONY: test3
test3:
	@#export PYTHONPATH=.;./venv/bin/py.test --ignore=venv -vv
	python3 setup.py test

.PHONY: test2
test2:
	python2 setup.py test

.PHONY: test
test: test3 test2

.PHONY: version
version:
	@python3 setup.py --version

.PHONY: prepare_dist
prepare_dist:
	rm -rf dist/*
	python3 setup.py sdist bdist_wheel

.PHONY: deploy
deploy: prepare_dist
	@echo "Check whether repo is clean"
	git diff-index --quiet HEAD
	@echo "Check correct branch"
	if [[ "$$(git rev-parse --abbrev-ref HEAD)" != "master" ]]; then echo 'Not master branch'; exit 1; fi
	@echo "Add tag"
	git tag "v$$(python3 setup.py --version)"
	@echo "Start uploading"
	twine upload dist/*

.PHONY: docs
docs:
	export PYTHONPATH=..; cd docs; make html
