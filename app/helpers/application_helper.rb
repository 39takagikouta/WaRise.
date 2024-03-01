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

  def page_title(page_title = '')
    base_title = 'WaRise.'

    page_title.empty? ? base_title : page_title + ' | ' + base_title
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

      twitter: {
        card: 'summary_large_image',
        site: '@YA3lrpq2PnRc3ge',
        image: image_url('ogp.png')
      }
    }
  end
end
