#!/bin/sh

SOURCE_DIR="$1"
OUTPUT="$2"

if test -z "$SOURCE_DIR" || ! test -d "$SOURCE_DIR" || test -z "$OUTPUT"
then
	echo >&2 "USAGE: $0 <SOURCE_DIR> <OUTPUT>"
	exit 1
fi

print_config_list () {
	cat <<EOF
static const char *config_name_list[] = {
EOF
	sed -e '
	/^`*[a-zA-Z].*\..*`*::$/ {
	/deprecated/d;
	s/::$//;
	s/`//g;
	s/^.*$/	"&",/;
	p;};
	d' \
	    "$SOURCE_DIR"/Documentation/*config.adoc \
	    "$SOURCE_DIR"/Documentation/config/*.adoc |
	sort
	cat <<EOF
	NULL,
};
EOF
}

{
	echo "/* Automatically generated by generate-configlist.sh */"
	echo
	echo
	print_config_list
} >"$OUTPUT"
