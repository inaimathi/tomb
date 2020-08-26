;;;; src/tomb.lisp
(in-package #:tomb)

(defparameter *gen* (session-token:make-generator :token-length 16))

(defun entomb (string &key (salt (funcall *gen*)) (cost 10) (cipher-name :blowfish))
  (let* ((arr (ironclad:ascii-string-to-byte-array (concatenate 'string string salt)))
	 (initial-hash (hash-for-tomb arr cipher-name))
	 (cipher (ironclad:make-cipher cipher-name :key initial-hash  :mode :ecb))
	 (output (make-sequence '(SIMPLE-ARRAY (UNSIGNED-BYTE 8) (*)) (length initial-hash))))
    (ironclad:encrypt cipher initial-hash output)
    (loop repeat (expt 2 cost)
       do (ironclad:encrypt-in-place cipher output))
    (format nil "$0w$~a$~a$~a$~a"
	    cipher-name
	    cost
	    salt
	    (ironclad:byte-array-to-hex-string output))))

(defun hash-for-tomb (arr cipher-name)
  (ironclad:digest-sequence
   (case cipher-name
     (:threefish512 :sha512)
     (:threefish1024 :skein1024)
     (t :sha256))
   arr))

(defun tomb-matches? (string hashed)
  (destructuring-bind (name cipher-name cost salt hash) (split-sequence:split-sequence #\$ hashed :remove-empty-subseqs t)
    (declare (ignore hash))
    (assert (string= name "0w"))
    (let ((cost (parse-integer cost))
	  (cipher-name (intern cipher-name :keyword)))
      (string= (entomb string :salt salt :cost cost :cipher-name cipher-name) hashed))))
