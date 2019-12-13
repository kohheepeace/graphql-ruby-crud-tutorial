# Chap3 Create model and Dummy data
**Goal of this chapter**
1. Create User and Post model
2. Create dummy data

*This chapter is not related with graphql-ruby!

## Step1. Create User
`terminal`
```bash
rails g model User name image
rails db:migrate
```

## Step2. Create Post model
`teminal`
```bash
rails g model Post title body user:references
rails db:migrate
```

## Step3. Edit user.rb
`models/user.rb`
```ruby
# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  image      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  validates :name, presence: true # this is up to you
  has_many :posts, dependent: :destroy
end
```

## Step4. Edit post.rb
*This is validation is up to your use-case.


`models/post.rb`
```ruby
# == Schema Information
#
# Table name: posts
#
#  id         :bigint(8)        not null, primary key
#  body       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint(8)
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Post < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  belongs_to :user
end
```

## Step5. Create dummy data
`Gemfile`
```
...
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
```

`terminal`
```bash
bundle
```

`terminal`
```bash
rails c
User.create(name: Faker::Name.name, image: Faker::Avatar.image)
Post.create(title: Faker::Book.title, body: Faker::Lorem.paragraph, user_id:1)
```
​
​Finish!

