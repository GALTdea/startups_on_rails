# Rails MVC Structure

This rule defines Rails MVC patterns for quick navigation.

## Files

```
app/models/**/*.rb @models
app/views/**/*.{erb,html.erb,haml} @views
app/controllers/**/*.rb @controllers
app/helpers/**/*.rb @helpers
app/javascript/controllers/**/*.js @stimulus_controllers
```

## When in models, suggest relationships

When `app/models/**/*.rb`

- `belongs_to :(\w+)` → `app/models/$1.rb`
- `has_many :(\w+)` → `app/models/$1.rb` 