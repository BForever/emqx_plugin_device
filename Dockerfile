FROM	emqx/emqx
#ADD	./etc/*	/opt/emqx/etc/plugins
ADD	./priv/*	/opt/emqx/releases/3.0/schema
RUN	echo >>/opt/emqx/data/loaded_plugins "emqx_plugin_http_auth."
RUN	echo >>/opt/emqx/data/loaded_plugins "emqx_plugin_template."

