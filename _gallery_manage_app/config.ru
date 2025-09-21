require_relative "config/boot"

run -> (env) { Routes.call(env) } # allows Routes to autoload
