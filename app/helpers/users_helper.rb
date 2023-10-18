module UsersHelper
  def seconds_to_time_format(seconds)
    minutes = seconds / 60
    remaining_seconds = seconds % 60
    "%02d:%02d" % [minutes, remaining_seconds]
  end
end
