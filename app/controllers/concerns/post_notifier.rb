# Purpose: Sends an email to all users when a new post is created 目的: 新しい投稿が作成されたときにすべてのユーザーに電子メールを送信します。
module PostNotifier
  extend ActiveSupport::Concern

  included do
    after_action :notify_users, only: [:create]
  end

  private

  # ユーザーに通知を送るメソッド
def notify_users
  # 投稿がデータベースに保存されているか確認
  if @post.persisted?
    # コンソールに通知を表示
    puts "すべてのユーザーにメールを送信中"

    # ユーザーテーブルから投稿者を除いたすべてのユーザーを取得
    # そして、それぞれのユーザーに対してメールを非同期で送信
    User.where.not(id: @post.user_id).each do |user|
      # PostMailerを使って新しい投稿のメールを作成し、非同期で送信
      PostMailer.new_post_email(user, @post).deliver_later
    end
  end
end
end

# このコード module PostNotifier は、Ruby on Railsのアプリケーションでよく見られるActiveSupportコンセルン（Concern）です。これは、コントローラーやモデルに再利用可能な機能を追加するのに役立つ方法の一つです。

# このConcernは、PostNotifierという名前のモジュールを定義しています。そして、その中で included ブロックがあります。このブロックは、Concernが他のクラスやモジュールに組み込まれるときに実行されるコードを指定します。

# 具体的には、after_action :notify_users, only: [:create] が定義されています。これは、アクション（コントローラーのメソッド）が実行された後に notify_users メソッドを呼び出すように設定しています。ただし、このafter_actionは:create アクションに対してのみ実行されるように指定されています。

# つまり、このConcernは、Postモデル（またはそれを継承したモデル）が生成され、かつcreateアクションが実行された後に、notify_usersメソッドが呼び出されるようになります。これによって、新しい投稿が作成された際にユーザーに通知を送るなどの処理を実行できます。
