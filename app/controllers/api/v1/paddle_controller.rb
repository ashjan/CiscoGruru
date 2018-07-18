class API::V1::PaddleController < ApplicationController
  skip_before_action :verify_authenticity_token

  def hook_callback
    logger.info "[PAYMENT] callback triggered"
    logger.info params.inspect
    if params[:alert_name] == "subscription_created"
      subscription_created
    elsif params[:alert_name] == "subscription_payment_succeeded"
      subscription_payment_succeeded
    elsif params[:alert_name] == "subscription_cancelled"
      subscription_cancelled
    end
    head 200
  end

  private

  def subscription_created
    user_id = params[:passthrough]
    user = User.find user_id
    user.account.update({
      account_type: "pro",
      update_url: params[:update_url],
      cancel_url: params[:cancel_url],
      subscription_status: params[:status],
      next_bill_date: params[:next_bill_date],
      paddle_subscription_id: params[:subscription_id],
      paddle_subscription_plan_id: params[:ubscription_plan_id]
      })
  end

  def subscription_cancelled
    user_id = params[:passthrough]
    user = User.find user_id
    user.account.update({
      account_type: "free",
      subscription_status: params[:status]
      })
  end

  def subscription_payment_succeeded
    user_id = params[:passthrough]
    user = User.find user_id
    Payment.create({
        user: user,
        account: user.account,
        country: params[:country],
        currency: params[:currency],
        earnings: params[:earnings],
        email: params[:email],
        fee: params[:fee],
        next_bill_date: params[:next_bill_date],
        paddle_order_id: params[:order_id],
        payment_tax: params[:payment_tax],
        sale_gross: params[:sale_gross],
        paddle_subscription_id: params[:subscription_id],
        paddle_subscription_plan_id: params[:subscription_plan_id]
      })
  end
end