#!/bin/sh

repo_dir() {
    basename "$(git rev-parse --show-toplevel)"
}

super_repo_dir() {
    basename "$(git rev-parse --show-superproject-working-tree)"
}

in_git_repo() {
    # returns exit code 0 if in a repo, otherwise returns exit code 1
   test "$(git status &>/dev/null ; echo $?)" -eq 0
}

in_git_submodule() {
    # returns exit code 0 if in a submodule, otherwise returns exit code 1
    test ! -z "$(super_repo_dir)"
}

parent_repo_desc() {
    if in_git_submodule ; then
        echo "[$(super_repo_dir)]"
    else
        echo ""
    fi
}

repo_desc() {
    if in_git_repo ; then
       if in_git_submodule ; then
         super_part="$(super_repo_dir) > "
       else
         super_part=''
       fi

       repo_part="$(repo_dir)"

       echo "${super_part}""${repo_part}"
    else
      echo ''
    fi
}
