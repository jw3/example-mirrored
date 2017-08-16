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

### to verify
- do builds for all branches get kicked off automatically
  - if so how do you limit them, dont want 20 branches building on a mirror that has 0-1 updates
- instead of injecting the ci config, would it be possible to use the GitLab API and pass the ci config along
  - this call could be made for each changed branch, and would be clearer than tacking the ci config on the repo

### notes
- target only branches are deleted when mirror push occurs (makes sense)
- target repo cannot have protected branches

### references
- https://git.wiki.kernel.org/index.php/Git_FAQ#How_do_I_clone_a_repository_with_all_remotely_tracked_branches.3F
- https://stackoverflow.com/questions/6865302/push-local-git-repo-to-new-remote-including-all-branches-and-tags

## Goals

Have a script that runs with cron

## Prototype

1. Initialize the tracking of the current branches

  `mirror.sh init https://github.com/jw3/example-mirrored.git`

This will create a .mig file that lists all the branches currently in the source repo with the hash at their head.

2. Mirror with

  `mirror.sh mirror https://github.com/jw3/example-mirrored.git https://user:token@gitlab.corp/jw3/example-mirrored-github-repo.git`

This will install a ci config on each branch that changed, resulting in a new build being started.  When the next mirror takes place, if the branch has not changed, the ci config will be gone.
