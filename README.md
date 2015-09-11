# Redmine Restrict Tracker

Restrict root and child trackers to a certain list.

# Run tests

Make sure you have the testing gems plugin:
```
git clone git@github.com:sdwolf/redmine_testing_gems.git
bundle install
```

Then run
```
rake redmine:plugins:test NAME=r edmine_restrict_tracker
```

To view test coverage go to `plugins/redmine_restrict_tracker/tmp/coverage`
