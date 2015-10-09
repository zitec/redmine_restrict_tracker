FactoryGirl.define do
  factory :user do
    sequence(:firstname) {|count| "Sample Firstname #{ count }" }
    sequence(:lastname) {|count| "Sample Lastname #{ count }" }
    sequence(:login) {|count| "sample-login-#{ count }" }
    sequence(:mail) {|count| "sample-mail-#{ count }@example.com" }
    created_on 1.day.ago.to_s(:db)
    last_login_on 1.day.ago.to_s(:db)
    updated_on 1.day.ago.to_s(:db)
    # The password is `jsmith`
    hashed_password 'bfbe06043353a677d0215b26a5800d128d5413bc'
    salt '67eb4732624d5a7753dcea7ce0bb7d7d'
    language 'en'
    mail_notification 'all'
    type 'User'
    status 1
    admin false

    factory :admin do
      # The password is `admin`
      hashed_password 'b5b6ff9543bf1387374cdfa27a54c96d236a7150'
      salt '82090c953c4a0000a7db253b0691a6b4'
      admin true
    end
  end
end
