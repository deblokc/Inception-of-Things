#! /bin/sh

gitlab-rails console <<EOF
u = User.new(username: 'nflan', email: 'nflan@example.com', name: 'Nicolas Flan', password: 'pa\$\$word2', password_confirmation: 'pa\$\$word2', admin: true)
u.skip_confirmation!
u.save!
token = u.personal_access_tokens.create(scopes: ['api','admin_mode'], name: 'nflan_token', expires_at: 365.days.from_now)
token.set_token('nflan_token')
token.save!
EOF