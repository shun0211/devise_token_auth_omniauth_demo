require 'httparty'
require 'json'

module Users
  class RequestsController < ApplicationController
    include HTTParty

    def authorization
      url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{params["id_token"]}"
      response = HTTParty.get(url)

      get_resource_from_google(response.parsed_response)

      tokens = @user.create_new_auth_token
      @user.save!

      set_headers(tokens)
      render json: { message: "成功しました！" }
    end

    private

    def get_resource_from_google(data)
      @user = User.where(
        uid: data["email"],
        provider: "google_oauth2"
      ).first_or_initialize

      assign_attrs(@user, data)

      @user
    end

    def assign_attrs(user, data)
      case data["iss"]
      when "accounts.google.com"
        user.assign_attributes({
          provider: "google_oauth2",
          uid: data["email"],
          first_name: data["given_name"],
          last_name: data["family_name"]
        })
      end
    end

    def set_headers(tokens)
      headers['access-token'] = (tokens['access-token']).to_s
      headers['client'] =  (tokens['client']).to_s
      headers['expiry'] =  (tokens['expiry']).to_s
      headers['uid'] = @user.uid
      headers['token-type'] = (tokens['token-type']).to_s
    end
  end
end
