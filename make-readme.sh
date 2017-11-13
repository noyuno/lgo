#!/bin/bash -e

temp=/tmp/make-readme
echo "" >$temp

find . -type f -name '*.go' -not -name '*_test.go' | while read line; do
    f=${line##*/}
    n=${f%.*}

    echo -e '### '$n'\n' >>$temp
    grep -B10 -e '^package' < $line | \
        grep -e '^//' --color=no | sed -e 's|^// ||' >>$temp
    echo "" >>$temp

    grep -ho 'func\s[A-Z].*{' < $line | \
        sed -e 's/{//g' -e 's/^/    /g' | sort >>$temp
    echo "" >>$temp
done

    cat << EOF >/tmp/description.sed
/\[\[functions\]\]/ {
    r $temp
    d
}
EOF
    sed -f /tmp/description.sed < description.md > readme.md

echo "Do not edit this file, please edit description.md instead." >> readme.md
