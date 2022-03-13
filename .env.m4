
# Docker user and group ids
# On linux these should match your ids
USER_ID=syscmd(id -u)
GROUP_ID=syscmd(id -g)

# You would typically use rake secret to generate a secure token. It is
# critical that you keep this value private in production.
SECRET_TOKEN=syscmd(openssl rand -base64 32)

# Unicorn is more than capable of spawning multiple workers, and in production
# you would want to increase this value but in development you should keep it
# set to 1.
#
# It becomes difficult to properly debug code if there's multiple copies of
# your application running via workers and/or threads.
WORKER_PROCESSES=1


# This will be the address and port that Unicorn binds to. The only real
# reason you would ever change this is if you have another service running
# that must be on port 8000.
LISTEN_ON=0.0.0.0:8010


# This is how we'll connect to PostgreSQL. It's good practice to keep the
# username lined up with your application's name but it's not necessary.
#
# Since we're dealing with development mode, it's ok to have a weak password
# such as yourpassword but in production you'll definitely want a better one.
#
# Eventually we'll be running everything in Docker containers, and you can set
# the host to be equal to postgres thanks to how Docker allows you to link
# containers.
#
# Everything else is standard Rails configuration for a PostgreSQL database.
DATABASE_URL=postgresql://drkiq:test_db_password@postgres:5432/drkiq?encoding=utf8&pool=5&timeout=5000


# Both of these values are using the same Redis address but in a real
# production environment you may want to separate Sidekiq to its own instance,
# which is why they are separated here.
#
# We'll be using the same Docker link trick for Redis which is how we can
# reference the Redis hostname as redis.
CACHE_URL=redis://redis:6379/0
JOB_WORKER_URL=redis://redis:6379/0
