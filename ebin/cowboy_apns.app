{application, 'cowboy_apns', [
	{description, "Cowboy Basic HTTP Authorization example"},
	{vsn, "1"},
	{modules, ['apns_handler','cowboy_apns','cowboy_apns_app','cowboy_apns_sup','test','toppage_handler']},
	{registered, [cowboy_apns_sup]},
	{applications, [kernel,stdlib,cowboy,apns,lager]},
	{mod, {cowboy_apns_app, []}},
	{env, []}
]}.