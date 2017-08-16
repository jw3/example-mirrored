Mirroring repos from GitHub to GitLab
===

### one way
1. `git clone --bare https://github.com/jw3/example-mirrored.git .git`
2. `git config --unset core.bare`
3. `git reset --hard`
4. `git push --mirror https://user:token@gitlab.corp/jw3/example-mirrored-github-repo.git`

### verified
- pulls new branches
- doesnt push unchanged branches

### unverified
- deletes branches
- works around target only branches

### references
- https://git.wiki.kernel.org/index.php/Git_FAQ#How_do_I_clone_a_repository_with_all_remotely_tracked_branches.3F
- https://stackoverflow.com/questions/6865302/push-local-git-repo-to-new-remote-including-all-branches-and-tags
