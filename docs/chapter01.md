# Chap1 Rails Api App setup
!!! abstract "Goal of this chapter"
    1. Just Create Rails Api app

​

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


## Gem for auto check

​- [annotate_models](https://github.com/ctran/annotate_models) - Annotate Rails classes with schema and routes info

​

### - annotate_models​
To automatically annotate every time you run db:migrate 

`Gemfile`
```
group :development do
  gem 'annotate'
end
​```

`terminal`
```bash
bundle
rails g annotate:install
​
Running via Spring preloader in process 53096
create  lib/tasks/auto_annotate_models.rake
```

Ref: https://github.com/ctran/annotate_models#configuration-in-rails​

​

Finish!