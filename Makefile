PROJECT = cowboy_apns 
PROJECT_DESCRIPTION = Cowboy Basic HTTP Authorization example
PROJECT_VERSION = 1

DEPS = cowboy apns lager
REL_DEPS = cowboy  
dep_cowboy_commit = master
dep_apns = git https://github.com/inaka/apns4erl 2.2.0
ERLC_OPTS = +'{parse_transform, lager_transform}'

include ./erlang.mk
