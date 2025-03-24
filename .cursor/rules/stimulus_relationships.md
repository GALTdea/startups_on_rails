# Stimulus Controller Relationships

Links Stimulus controllers with views that use them.

## When in Stimulus controllers, suggest views

When `app/javascript/controllers/**/*_controller.js`

- `controllers/(\w+)_controller.js` → `app/views/**/*data-controller="$1"*` 