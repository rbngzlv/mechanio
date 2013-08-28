# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Mechanio::Application.config.secret_key_base = '20f4f56f4c9296745672039ed569cb3121b0709ef5d0213fa90a36790a9574829740bb519a4f32bceead5e9be5fb2afeb56f93acdfd461371eca8da57524e465'
