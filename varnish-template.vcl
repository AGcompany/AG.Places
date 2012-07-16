#for $b in $backends
backend backend_$b['ID'] {
    .host = "$b['host']";
    .port = "$b['port']";
    .connect_timeout = $connect_timeout;
    .first_byte_timeout = $first_byte_timeout;
    .between_bytes_timeout = $between_bytes_timeout;
}
#end for

acl purge {
    "localhost";
    "127.0.0.1";

}

sub vcl_hash {

    hash_data(req.url);
    hash_data(req.http.host);
    
    if( req.http.Cookie ~ "__ac" && req.http.X-Varnish-Hashed-On ) {
        set req.http.X-Varnish-Hashed-On = req.http.X-Varnish-Hashed-On + " logged in";
    }
    else if (req.http.X-Varnish-Hashed-On) {
        set req.http.X-Varnish-Hashed-On = req.http.X-Varnish-Hashed-On + " anonymous";
    }
    hash_data(req.http.X-Varnish-Hashed-On);
    return (hash);
}

sub vcl_recv {
    set req.grace = 120s;

    if (req.request == "PURGE") {
        if (!client.ip ~ purge) {
            error 405 "Not allowed.";
        }
        return(lookup);
    }

    if (req.request != "GET" &&
        req.request != "HEAD" &&
        req.request != "PUT" &&
        req.request != "POST" &&
        req.request != "TRACE" &&
        req.request != "OPTIONS" &&
        req.request != "DELETE") {
        /* Non-RFC2616 or CONNECT which is weird. */
        return(pipe);
    }

    if (req.request != "GET" && req.request != "HEAD") {
        /* We only deal with GET and HEAD by default */
        return(pass);
    }
    
    if (req.http.Cookie && req.http.Cookie ~ "__ac") {
        # Force lookup of specific urls unlikely to need protection
        if (req.url ~ "(/@@/|\+\+resource\+\+)") {
            return(lookup);
        }
        
        return(pass);
    }

    remove req.http.Accept-Encoding;

    return(lookup);
}

sub vcl_pipe {
    # This is not necessary if you do not do any request rewriting.
    set req.http.connection = "close";
}

sub vcl_hit {
    if (req.request == "PURGE") {
        ban_url(req.url);
        error 200 "Purged";
    }

    if (!(obj.ttl > 0s)) {
        return(pass);
    }
}

sub vcl_miss {
#$ {vcl_miss}
    if (req.request == "PURGE") {
        error 404 "Not in cache";
    }

}

sub vcl_fetch {
    set beresp.grace = 120s;
#$ {vcl_fetch}

    if (!(beresp.ttl > 0s)) {#$ {header_fetch_notcacheable}
        return(hit_for_pass);
    }

    ### got Session
    if (beresp.http.Set-Cookie) {#$ {header_fetch_setcookie}
        return(hit_for_pass);
    }

    ### Cache-Control=private header from the backend
    if (beresp.http.Cache-Control ~ "(private|no-cache|no-store)") {#$ {header_fetch_cachecontrol}
        return(hit_for_pass);
    }

    ###
    if (beresp.http.Authorization && !beresp.http.Cache-Control ~ "public") {#$ {header_fetch_auth}
        return(hit_for_pass);
    }
    #$ {header_fetch_insert}
}

#if $verbose_headers
sub vcl_deliver {
    set resp.http.X-Varnish-Hashed-On = req.http.X-Varnish-Hashed-On;
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
        set resp.http.X-Cache-Hits = obj.hits;
    } else {
        set resp.http.X-Cache = "MISS";
    }
}
#end if
