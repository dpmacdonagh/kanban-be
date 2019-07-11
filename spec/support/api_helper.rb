module ApiHelper
  def authorize_header(user)
    token = JsonWebToken.encode(user_id: user.id)
    request.headers.merge!({ 'Authorization': "Bearer #{token}"})
  end
end