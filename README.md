nginx configuration
location / {
	root   /u01/;
	autoindex on;
  autoindex_exact_size off;
	autoindex_localtime on;
}

