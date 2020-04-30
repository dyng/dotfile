curl_benchmark() {
    format="

    time_namelookup: %{time_namelookup}
    time_connect: %{time_connect}
    time_appconnect: %{time_appconnect}
    time_pretransfer: %{time_pretransfer}
    time_redirect: %{time_redirect}
    time_starttransfer: %{time_starttransfer}
    ----------
    time_total: %{time_total}
    "
    /usr/local/opt/curl/bin/curl -v -w "$format" $@
}
