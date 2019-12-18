# Chap1 Rails Api App setup

## Todo in this chapter
- Create Rails Api app


## Step1 Rails new​

`terminal`
```bash
rails new rails-api-graphql-crud-tuto --api -T --database=postgresql
cd rails-api-graphql-crud-tuto
rails db:create
git init
git add .
git commit -m "Initial Commit"
```

`-T` option is for...

`terminal`

```bash
  rails -h  ...  -T, [--skip-test], [--no-skip-test] # Skip test files
```


## Step2 Add annotate_models​

`Gemfile`
```ruby
group :development do
  gem 'annotate'
end
```

`terminal`
```bash
bundle
```

```bash
rails g annotate:install
​
Running via Spring preloader in process 53096
create  lib/tasks/auto_annotate_models.rake
```

Ref: https://github.com/ctran/annotate_models#configuration-in-rails​

​

Finish!