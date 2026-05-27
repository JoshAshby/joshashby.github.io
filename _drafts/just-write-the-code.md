---
title: Just write the code
---

The other day I came across the following test in our codebase:

```ruby
%w[ queue run stop ].each do |status|
	assert_equal(true, status.in?(task.log), "#{task.name}: #{status}")
end
```

There's a bit to unpack here but take this alternative:

```ruby
assert_includes(task.log, "queue", "Task log for #{task.name} should include event: queue")
assert_includes(task.log, "run", "Task log for #{task.name} should include event: run")
assert_includes(task.log, "stop", "Task log for #{task.name} should include event: stop")
```

Is it perfect? No. Is it better? I think so.

This particular test suite struggles against
