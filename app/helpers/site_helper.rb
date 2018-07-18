module SiteHelper
  def select_plan_button(paddle_product_id: 0, primary_button: false)
    if current_user.is_signed_in?
      if current_user.account.free? && paddle_product_id != 0
        url = "https://pay.paddle.com/checkout/#{paddle_product_id}?guest_email=#{current_user.email}&quantity_variable=0&passthrough=#{current_user.id}&success=https://www.dbdesigner.net/registrations/thankyou"
        content_tag :div, class: "panel-footer" do
          _choose_plan_button url: url, text: "Upgrade", primary_button: primary_button
        end
      end
    else
      content_tag :div, class: "panel-footer" do
        _choose_plan_button url: "/registrations/new?plan_id=#{paddle_product_id}", text: "Register", primary_button: primary_button
      end
    end
  end

  private

  def _choose_plan_button url:, text:, primary_button: false
    classes = "btn btn-lg btn-block"
    if primary_button
      classes = classes + " btn-primary"
    else
      classes = classes + " btn-default"
    end
    content_tag :a, text, class: classes, href: url, rel: "nofollow"
  end
end
