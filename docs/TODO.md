# ToDo

## Resume

### Write a manual of how to start the project

Make an manual of how to start the project from an .zip file, and then
upload the manual and the file to github or linkedin.

### My Git flow

I just finished the deploy and rollback on database, I will try the rollback
on backend and frontend by using `git revert`, something like make up an
scenery which I need to rollback the three layers (front, back and db).

**The problem that I have now** is that when i'm developing I do many commit, and
many of them are irrelevant on a production level, so...

I'm thinking on create a feature branch and then merge it to the environment I what
to deploy, using `--no-commit` y `--no-ff` to reduce the commits

```shell
git checkout back_PRODUCTION
git checkout -b new_feature_1

# make changes
git checkout back_develop
# I merge the changes and keep the noise out
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"

# if everything goes well I do the same in test
git checkout back_test
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"

# If everything goes well I do the same in PRODUCTION
git checkout back_PRODUCTION
git merge --no-commit --no-ff new_feature_1
git add . && git commit -m "implement of new_feature_1"
```

So in theory this way there is no much details hidden, because
the environment branches are just to deploy in previous environments
without modify the PRODUCTION branch.
and the feature branches should be merged/committed the most often
posible.

## List

- [ ] Make a drawing of how would work the git strategy and their commits.
- [ ] Create a happy-path scenery to deploy in all layers.
- [ ] Create an all-bad scenery to rollback in all layers.
- [ ] Include it in your the blog.
