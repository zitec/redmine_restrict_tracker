FactoryGirl.define do
  factory :user do
    status 1
    last_login_on '2006-07-19 22:57:52 +02:00'
    language 'en'
    # The password is `admin`
    salt '82090c953c4a0000a7db253b0691a6b4'
    hashed_password 'b5b6ff9543bf1387374cdfa27a54c96d236a7150'
    created_on '2006-07-19 19:12:21 +02:00'
    updated_on '2006-07-19 22:57:52 +02:00'
    admin false
    lastname 'User'
    firstname 'Redmine'
    mail_notification 'all'
    login 'user'
    type 'User'
    mail 'test@test.com'

    factory :admin do
      admin true
    end
  end
end
