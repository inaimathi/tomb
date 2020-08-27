;;;; test/tomb.lisp

(in-package #:tomb-test)

(tests
 (subtest "the tomb function"
   (let ((pass "an arbitrary passphrase"))
     (isnt (entomb pass) (entomb pass)
	   "Equal strings don't collide by default"))

   (for-all ((pass a-string))
     (is= (entomb pass :salt "salt") (entomb pass :salt "salt"))
     "Equal strings collide if given the same salt")

   (let ((long-pass "tomb doesnt truncate even when the password is ridiculously long and probably harder to type out than is really worth it from the security perspective anyway. glarble flargle bloo! 9j430rd43875-=912ow'498134-98213u)(*_*&)*&^%(&$@(&^@_(*&(_@*&)(*#^@*&%&^$%^@*&()@_@
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed rutrum id enim eu facilisis. Suspendisse sed libero est. Aenean hendrerit et sem a iaculis. Vestibulum urna lacus, tempor ac lorem interdum, molestie sollicitudin erat. In lorem lectus, scelerisque a consequat ultrices, condimentum et odio. Vivamus lobortis risus sit amet neque aliquet, sit amet molestie ipsum convallis. Vivamus nec fringilla diam. Aenean ac commodo nulla, ut euismod erat. Cras id ex scelerisque, vestibulum risus quis, faucibus nulla. Mauris quis aliquam augue, egestas auctor risus. Proin condimentum mi at libero congue varius.

Quisque ut consectetur augue. Sed cursus aliquet urna, eget egestas ligula tristique a. Aliquam consectetur aliquam ante, eget placerat metus pretium vitae. Nunc non laoreet lacus, vitae finibus ante. Proin elit nulla, auctor vitae ligula eget, mollis vestibulum est. Morbi ut vehicula erat. Suspendisse imperdiet gravida finibus. Morbi et porta enim. Integer vulputate vehicula metus, et lacinia erat efficitur sed. Phasellus porta dignissim condimentum.

Duis iaculis convallis elit, at auctor est rhoncus vel. Sed semper turpis neque, sit amet viverra justo gravida id. Vestibulum sagittis vitae leo sed vestibulum. Nullam convallis viverra enim vitae ullamcorper. Donec sapien erat, ultricies vitae interdum eu, imperdiet vitae ante. Donec gravida scelerisque porttitor. Curabitur sagittis varius posuere. Aliquam tempor est nisl, efficitur congue eros suscipit vel. Fusce sed semper ipsum, sed maximus elit. Etiam nec lacus odio.

Morbi porta ipsum non velit venenatis, sed convallis justo sagittis. Suspendisse consequat bibendum felis in rutrum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum sed faucibus dolor. Praesent ut elit eget tortor porta viverra. Nunc id libero vitae sapien mollis pharetra eget ultricies nisi. Fusce tincidunt, tellus sed pharetra tincidunt, arcu ex facilisis ligula, quis scelerisque nunc est eu dolor. Nam lacinia, enim ac euismod consectetur, neque diam scelerisque quam, ut hendrerit elit enim placerat dui. Nam accumsan non nisi sit amet finibus. Duis semper sodales lobortis. Sed congue ultricies euismod. Etiam in lacus sit amet massa sodales tempor ac in nisi. Mauris sagittis in enim ut lacinia. Suspendisse bibendum nisl vitae aliquet scelerisque.

Fusce suscipit, mi at iaculis sagittis, arcu lacus dictum libero, eget pulvinar felis quam sit amet erat. Maecenas et tortor ornare enim ornare porttitor id id erat. Nullam rutrum, tortor eget congue dignissim, dolor purus congue dolor, eget pulvinar odio risus ultricies quam. Vivamus eleifend odio purus, a suscipit lacus pulvinar id. Quisque euismod diam mi, ac dictum dolor gravida sed. Quisque luctus, magna vel consectetur fermentum, ipsum eros posuere metus, ut consectetur ligula ligula in sapien. Nullam consequat quam nec mi molestie aliquet. Quisque eu pharetra massa. Donec varius lacinia massa id suscipit. Nulla a nulla urna. Donec tincidunt congue nisi at rhoncus. Pellentesque ut augue non tortor gravida tincidunt. Curabitur a suscipit urna, quis venenatis ligula. Suspendisse maximus mauris metus, eu ultricies risus tristique vel. Fusce dignissim elit ac consectetur dignissim. Nam egestas sollicitudin leo, vitae aliquam orci interdum et."))
     (isnt (entomb long-pass :salt "salt")
	   (entomb (subseq long-pass 0 (- (length long-pass) 1)))
	   "Doesn't truncate long passwords"))

   (for-all ((pass a-string)
	     (cost (one-of 8 9 10 11 12 13 14 15 16))
	     (cipher (one-of :aes :aria :blowfish :camellia :twofish :threefish256 :threefish512 :threefish1024)))
     (is= (entomb pass :salt "salt") (entomb pass :salt "salt"))
     "Works on costs between 8 and 20, and many ECB-capable ciphers from ironclad"))

 (subtest "the tomb-matches? function"
   (for-all ((pass a-string)
	     (cost (one-of 8 9 10 11 12 13 14 15 16))
	     (cipher (one-of :aes :aria :blowfish :camellia :twofish :threefish256 :threefish512 :threefish1024)))
     (is= (tomb-matches? pass (entomb pass :cost cost :cipher-name cipher)) t)
     "Works on everything tomb does")))
