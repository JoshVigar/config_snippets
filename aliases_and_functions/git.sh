alias g='git'
alias gs='git status'
alias gm='git checkout master && git pull origin master'
alias ga='git add -A'
alias gc='git commit'
alias gp='git push origin HEAD'
alias gl='git log'
alias gam='git commit --amend --no-edit'
alias gpf='git push origin HEAD --force-with-lease'
alias gac='git add -A && git commit'
alias gacp='git add -A && git commit && git push origin HEAD'
alias gbrn='git checkout -b'
alias gbr='git checkout'
alias gd='git diff'
alias gbrbyebye='git branch | grep -v "master" | xargs git branch -D'

# Start an interactive rebase with of X number of commits from head.
gre() {
  g rebase -i HEAD~"$1"
}

# List git branches in order of last updated.
gbrwhen() {
  for branch in `git branch | perl -pe s/^..//`; do
  echo -e `git show --pretty=format:"%Cgreen%ci %Cblue %cr%Creset" $branch -- |
    head -n 1`\\t$branch
  done | sort -r
}
