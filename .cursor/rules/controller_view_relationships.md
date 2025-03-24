# Controller-View Relationships

Links controllers with their corresponding views.

## When in controllers, suggest views

When `app/controllers/**/*_controller.rb`

- `class (\w+)Controller` → `app/views/$1/**/*.erb` 