# $redis = Redis::Namespace.new("goods", :redis => Redis.new)

if Rails.env.development? || Rails.env.test?
  $redis = Redis.new
else
  $redis = Redis.new(
      host: "#{ENV["REDIS_HOST"]}",
      port: "#{ENV["REDIS_PORT"]}",
      password: "#{ENV["REDIS_PASSWORD"]}"
  )
end

#$redis.flushdb if Rails.env = "test"