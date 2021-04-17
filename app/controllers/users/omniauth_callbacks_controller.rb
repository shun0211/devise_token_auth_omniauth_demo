module Users
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    def omniauth_success
      super
    #   Required because the default method does not set the header
      update_auth_header
    end

    # concerns/user.rb
    # def update_auth_header(token, client = 'default')
    #   headers = build_auth_header(token, client)
    #   clean_old_tokens
    #   save!

    #   headers
    # end

    protected

    # To avoid ActiveModel::ForbiddenAttributesError
    def assign_provider_attrs(user, auth_hash)
      case auth_hash["provider"]
      when "google_oauth2"
        user.assign_attributes({
          name: auth_hash["info"]["name"],
          image: auth_hash["info"]["image"],
          email: auth_hash["info"]["email"]
        })
      else
        super
      end
    end
  end
end
