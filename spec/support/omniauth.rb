OmniAuth.config.test_mode = true

OmniAuth.config.add_mock :facebook,      uid: '1', nickname: 'user_fb',    email: 'user1@fb.com'
OmniAuth.config.add_mock :google_oauth2, uid: '2', nickname: 'user_gmail', email: 'user2@gm.com'
