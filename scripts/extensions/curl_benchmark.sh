curl_benchmark() {
    format="

    time_namelookup: %{time_namelookup}
    time_connect: %{time_connect}
    time_appconnect: %{time_appconnect}
    time_redirect: %{time_redirect}
    time_pretransfer: %{time_pretransfer}
    time_starttransfer: %{time_starttransfer}
    time_total: %{time_total}
    ----------
    time_total: %{time_total}
    "
    curl -v -w "$format" $@
}
