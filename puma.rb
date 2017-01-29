workers (ENV['PUMA_WORKERS'] || 1).to_i
threads 1, (ENV['MAX_THREADS'] || 10).to_i

bind "tcp://0.0.0.0:9292"
pidfile "/var/run/puma.pid"
state_path "/var/run/puma.state"
