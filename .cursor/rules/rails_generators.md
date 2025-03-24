# Rails Generators Usage

Always use Rails generators when creating new files in the project. This ensures consistency and follows Rails conventions.

## Generator Preferences

Always suggest appropriate Rails generators before manually creating files. Use these common generators:

```
# Database Migrations
bin/rails generate migration AddFieldToModel field:type
bin/rails generate migration CreateModels field:type other_field:type

# Models
bin/rails generate model ModelName field:type other_field:type:index

# Controllers
bin/rails generate controller ControllerName action1 action2

# Stimulus Controllers
bin/rails generate stimulus controller_name action1 action2

# Mailers
bin/rails generate mailer MailerName action1 action2

# Jobs
bin/rails generate job JobName

# Resources
bin/rails generate resource ResourceName field:type other_field:type

# Concerns
bin/rails generate concern ConcernName
```

## Guidelines

1. Always prefer generators over manual file creation
2. Include appropriate options like `--skip-test` only when explicitly requested 
3. Never create migration files directly; always use generators
4. Use correct naming conventions (singular for models, plural for controllers)
5. For database migrations, include appropriate indexes, foreign keys, and constraints 