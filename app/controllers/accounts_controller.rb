class AccountsController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = User.new(new_user_params)

    unless user.save
      return render_errors(user)
    end

    account = Account.new(owner: user)

    user.accounts << account

    unless account.save
      return render_errors(account)
    end

    token = user.exchange_password_for_token(new_user_params[:password])

    render_json(account, context: user, root: :account)
  end

  def me
    render_json(current_user.account, root: :account, context: current_user)
  end

  def new_user_params
    params.permit(:email, :password)
  end
end
