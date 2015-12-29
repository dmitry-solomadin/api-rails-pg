# Create users
user = User.create! first_name: Forgery('name').first_name, last_name: Forgery('name').last_name, role: 'USER',
                    email: 'user@gmail.com', password: 'user'
other_user = User.create! first_name: Forgery('name').first_name, last_name: Forgery('name').last_name, role: 'USER',
                          email: 'other_user@gmail.com', password: 'user'
User.create! first_name: Forgery('name').first_name, last_name: Forgery('name').last_name, role: 'ADMIN',
             email: 'admin@gmail.com', password: 'admin'

users = [user, other_user]

# Create posts
posts = 5.times.map do
  Post.create! body: Forgery(:lorem_ipsum).words(150).split.shuffle.join(' '),
               header: Forgery('name').industry, author: users.sample
end

# Create comments on posts
comments = 15.times.map do
  Comment.create! text: Forgery(:lorem_ipsum).words(15).split.shuffle.join(' '),
                  parent: posts.sample, author: users.sample
end

# Create comments on comments
15.times.map do
  Comment.create! text: Forgery(:lorem_ipsum).words(15).split.shuffle.join(' '),
                  parent: comments.sample, author: users.sample
end
