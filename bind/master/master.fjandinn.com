$TTL 1d
$ORIGIN fjandinn.com.
@  1d  IN SOA ns1.first-ns.de. hostmaster.fjandinn.com. (
      2   ; serial
      3h  ; refresh
      30m ; retry
      1w  ; expire
      3h  ; minimum
     )

       IN  NS     ns1.first-ns.de.
       IN  NS     robotns2.second-ns.de.
       IN  NS     robotns3.second-ns.com.

       IN  MX  10 mail.nix.is.

fjandinn.com.            IN  A      5.9.157.150
www                  IN  CNAME  fjandinn.com.
