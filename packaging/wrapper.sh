#!/bin/bash
set -e

# Figure out where this script is located.
SELFDIR="`dirname \"$0\"`"
SELFDIR="`cd \"$SELFDIR\" && pwd`"

# Tell Bundler where the Gemfile and gems are.
export BUNDLE_GEMFILE="$SELFDIR/lib/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG

PORT="8099"
ENVIRONMENT="production"

show_help() {
  cat << EOF
`basename $0` [-p PORT] [-e ENVIRONMENT]

Options
    -p,     Port to listen on. Defaults to $PORT
    -e,     Rack environment. Default is $ENVIRONMENT
    -h,     Show help
EOF
}

while getopts "hp:e:" FLAG; do
  case $FLAG in
    p)
      PORT=$OPTARG
      ;;
    e)
      ENVIRONMENT=$OPTARG
      ;;
    h)
      show_help
      exit 1
      ;;
  esac

done

# Run the actual app using the bundled Ruby interpreter, with Bundler activated.
exec "$SELFDIR/lib/ruby/bin/ruby" -rbundler/setup "$SELFDIR/lib/ruby/bin.real/puma" --port $PORT --environment $ENVIRONMENT "lib/app/config.ru"
