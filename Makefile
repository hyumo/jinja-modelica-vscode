.PHONY: patch minor major

patch:
	npm version patch --no-git-tag-version
	git add package.json package-lock.json
	git commit -m "chore: bump version to $$(node -p "require('./package.json').version")"

minor:
	npm version minor --no-git-tag-version
	git add package.json package-lock.json
	git commit -m "chore: bump version to $$(node -p "require('./package.json').version")"

major:
	npm version major --no-git-tag-version
	git add package.json package-lock.json
	git commit -m "chore: bump version to $$(node -p "require('./package.json').version")"

tag:
	@branch=$$(git rev-parse --abbrev-ref HEAD); \
	if [ "$$branch" != "master" ]; then \
		echo "Error: must be on master branch (currently on $$branch)"; exit 1; \
	fi
	git tag v$$(node -p "require('./package.json').version")
	git push --tags
