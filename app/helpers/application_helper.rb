module ApplicationHelper
  def flash_classname(message_type)
    case message_type
    when 'notice'
      'alert alert-info'
    when 'success'
      'alert alert-success'
    when 'error'
      'alert alert-error'
    when 'alert'
      'alert alert-warning'
    else
      'alert'
    end
  end

  def default_meta_tags
    {
      site: 'WaRise.',
      title: '「お笑い」と「アラーム」を合わせた、早起き促進サービス',
      reverse: true,
      charset: 'utf-8',
      description: 'WaRise（わらいず）は、設定時間に起床すると、ご褒美としてお笑い動画をレコメンドしてくれる、早起き促進アラームアプリです。',
      keywords: 'お笑い,アラーム',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      # Twitter用の設定を個別で設定する
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードにする
        site: '@YA3lrpq2PnRc3ge', # アプリの公式Twitterアカウントがあれば、アカウント名を書く
        image: image_url('ogp.png') # 配置するパスやファイル名によって変更すること
      }
    }
  end
end
