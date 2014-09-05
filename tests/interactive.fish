#!/usr/local/bin/fish
#
# Interactive tests using `expect`

for i in *.expect
    set -l base (basename $i .expect)

    expect -n -c 'set fish ../fish' -f $i >tmp.out ^tmp.err
    set -l tmp_status $status
    set res ok
    if not diff tmp.out $base.out >/dev/null
        set res fail
        echo "Output differs for file $i. Diff follows:"
        diff -u tmp.out $base.out
    end

    if not diff tmp.err $base.err >/dev/null
        set res fail
        echo "Error output differs for file $i. Diff follows:"
        diff -u tmp.err $base.err
    end

    if test $tmp_status != (cat $base.status)
        set res fail
        echo "Exit status differs for file $i."
    end

    if test $res = ok
        echo "File $i tested ok"
    else
        echo "File $i failed tests"
    end
end
