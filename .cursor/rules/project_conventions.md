# Project Conventions and Preferences

This file serves as the source of truth for AI assistance with this Ruby on Rails project.

## Rules for AI

- Use this file to understand how the codebase works
- Treat this rule/file as your "source of truth" when making code recommendations
- When creating migrations, always use `rails g migration` instead of creating the file yourself

## Project Tech Stack

- Web framework: Ruby on Rails
  - Minitest + fixtures for testing
  - Propshaft for asset pipeline
  - Hotwire Turbo/Stimulus for SPA-like UI/UX
  - TailwindCSS for styles
  - Lucide Icons for icons
- Database: PostgreSQL
- Jobs: Sidekiq + Redis
- External
  - Payments: Stripe
  - User bank data syncing: Plaid 
  - Market data: Synth (our custom API)

## Project conventions

These conventions should be used when writing code for this project.

### Convention 1: Minimize dependencies, vanilla Rails is plenty

Dependencies are a natural part of building software, but we aim to minimize them when possible to keep this open-source codebase easy to understand, maintain, and contribute to.

- Push Rails to its limits before adding new dependencies
- When a new dependency is added, there must be a strong technical or business reason to add it
- When adding dependencies, you should favor old and reliable over new and flashy 

### Convention 2: Leverage POROs and concerns over "service objects"

This codebase adopts a "skinny controller, fat models" convention. Furthermore, we put almost _everything_ directly in the `app/models/` folder and avoid separate folders for business logic such as `app/services/`.

- Organize large pieces of business logic into Rails concerns and POROs (Plain ole' Ruby Objects)
- While a Rails concern _may_ offer shared functionality (i.e. "duck types"), it can also be a "one-off" concern that is only included in one place for better organization and readability.
- When concerns are used for code organization, they should be organized around the "traits" of a model; not for simply moving code to another spot in the codebase.
- When possible, models should answer questions about themselves—for example, we might have a method, `account.balance_series` that returns a time-series of the account's most recent balances. We prefer this over something more service-like such as `AccountSeries.new(account).call`.

### Convention 3: Prefer server-side solutions over client-side solutions

- When possible, leverage Turbo frames over complex, JS-driven client-side solutions
- When writing a client-side solution, use Stimulus controllers and keep it simple!
- Especially when dealing with money and currencies, calculate + format server-side and then pass that to the client to display
- Keep client-side code for where it truly shines. For example, bulk selection is a case where server-side solutions would degrade the user experience significantly. When bulk-selecting entries, client-side solutions are the way to go and Stimulus provides the right toolset to achieve this.

### Convention 4: Sacrifice performance, optimize for simplicitly and clarity

This codebase is still young. We are still rapidly iterating on domain designs and features. Because of this, code should be optimized for simplicitly and clarity over performance.

- Focus on good OOP design first, performance second
- Be mindful of large performance bottlenecks, but don't sweat the small stuff

### Convention 5: Prefer semantic, native HTML features

The HTML spec has improved tremendously over the years and offers a ton of functionality out of the box. We prefer semantic, native HTML solutions over JS-based ones. A few examples of this include:

- Using the `dialog` element for modals
- Using `summary` / `details` elements for disclosures (or `popover` attribute)

The Hotwire suite (Turbo/Stimulus) works very well with these native elements and we optimize for this.

### Convention 6: Use Minitest + Fixtures for testing, minimize fixtures

Due to the open-source nature of this project, we have chosen Minitest + Fixtures for testing to maximize familiarity and predictability.

- Always use Minitest and fixtures for testing.
- Keep fixtures to a minimum. Most models should have 2-3 fixtures maximum that represent the "base cases" for that model. "Edge cases" should be created on the fly, within the context of the test which it is needed.
- For tests that require a large number of fixture records to be created, use Rails helpers to act as a "factory" for creating these.

### Convention 7: Use ActiveRecord for complex validations, DB for simple ones, keep business logic out of DB

- Enforce `null` checks, unique indexes, and other simple validations in the DB
- ActiveRecord validations _may_ mirror the DB level ones, but not 100% necessary. These are for convenience when error handling in forms. Always prefer client-side form validation when possible.
- Complex validations and business logic should remain in ActiveRecord 