class PurchaseController < ApplicationController
  require 'payjp'

  def index
    @post = Post.find(params[:post_id])
    card = Card.where(user_id: current_user.id).first
    if card.blank?
      #登録された情報がない場合にカード登録画面に移動
      redirect_to controller: "cards", action: "new"
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      #保管した顧客IDでpayjpから情報取得
      customer = Payjp::Customer.retrieve(card.customer_id)
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end

  def pay
    @post = Post.find(params[:post_id])
    if @post.buyer_id.present?
      redirect_to root_path, alert: "ごめん売りけれとるばい" and return
    end
    price = @post.price*1.1
    card = Card.where(user_id: current_user.id).first
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
    Payjp::Charge.create(
    :amount => price.truncate,
    :customer => card.customer_id,
    :currency => 'jpy', 
  )
  redirect_to action: 'done' and return #完了画面に移動
  end

  def done
    @product_buyer= Post.find(params[:post_id])
    @product_buyer.update( buyer_id: current_user.id)
  end
end
