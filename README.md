Mirroring repos from GitHub to GitLab
===

### mirroring
1. `git clone --bare https://github.com/jw3/example-mirrored.git .git`
2. `git config --unset core.bare`
3. `git reset --hard`
4. `git push --mirror https://user:token@gitlab.corp/jw3/example-mirrored-github-repo.git`

### topping off with additional files

Since it does not appear that you can keep source only branches, will have to bring in files from elsewhere.

1. `curl -O https://gitlab.corp/jw3/example-mirrored-github-repo-ci-config/raw/master/.gitlab-ci.yml`
2. `git add . && git commit -m 'add gitlab ci config'`
3. `git push https://user:token@gitlab.corp/jw3/example-mirrored-github-repo.git`

At this point, if the project is configured properly for CI, a build should be kicked off.

### verified mirroring
- pulls new branches
- doesnt push unchanged branches
- deletes branches

### notes
- target only branches are deleted when mirror push occurs (makes sense)
- target repo cannot have protected branches

### references
- https://git.wiki.kernel.org/index.php/Git_FAQ#How_do_I_clone_a_repository_with_all_remotely_tracked_branches.3F
- https://stackoverflow.com/questions/6865302/push-local-git-repo-to-new-remote-including-all-branches-and-tags
