$TTL 1d
$ORIGIN goosegoosego.com.
@  1d  IN SOA ns1.first-ns.de. hostmaster.goosegoosego.com. (
      3   ; serial
      3h  ; refresh
      30m ; retry
      1w  ; expire
      3h  ; minimum
     )

       IN  NS     ns1.first-ns.de.
       IN  NS     robotns2.second-ns.de.
       IN  NS     robotns3.second-ns.com.

       IN  MX     10 mail.goosegoosego.com.

goosegoosego.com.    IN  A      5.9.157.150
www                  IN  CNAME  goosegoosego.com.
www                  IN  A      5.9.157.150
