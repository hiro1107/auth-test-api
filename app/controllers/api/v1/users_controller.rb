class Api::V1::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    render json: @user, root: 'user'
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: "Successfully created a user" }
    else
      render json: { message: "Signup failed" }, status: 500
    end
  end

  def authenticate
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      render json: { userId: user.id, authToken: JWT.encode(user.attributes, 'secret') }
    else
      render json: { error: "Invalid email or password." }, status: 401
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password
    )
  end
end
