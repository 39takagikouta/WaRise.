module UsersHelper
  def seconds_to_time_format(seconds)
    return "未登録" if seconds.nil?

    minutes = seconds / 60
    remaining_seconds = seconds % 60
    "%02d:%02d" % [minutes, remaining_seconds]
  end
end
