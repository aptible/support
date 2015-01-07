App.Helpers = {
  gravatar_url: (email, size = 96) ->
    encoded_email = CryptoJS.MD5(email.trim().toLowerCase())
    "https://www.gravatar.com/avatar/#{encoded_email}.jpg?s=#{size}"
}
