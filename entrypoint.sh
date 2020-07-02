#!/bin/sh
version() {
  if [ -n "$1" ]; then
    echo "-v $1"
  fi
}

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

gem install -N rubocop $(version $INPUT_RUBOCOP_VERSION)

echo $INPUT_RUBOCOP_EXTENSIONS | xargs gem install -N

if [ -z ${BASE_BRANCH+x} ]; then
git diff origin/${BASE_BRANCH} --name-only --diff-filter=AM \
  | xargs rubocop ${INPUT_RUBOCOP_FLAGS} \
  | reviewdog -f=rubocop \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
else
rubocop ${INPUT_RUBOCOP_FLAGS} \
  | reviewdog -f=rubocop \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
fi
