;;;; tomb.asd

(asdf:defsystem #:tomb
  :description "A toy password hash library"
  :author "inaimathi <leo.zovic@gmail.com>"
  :license "MIT Expat"
  :version "0.0.1"
  :serial t
  :depends-on (#:ironclad #:session-token #:split-sequence)
  :components ((:module
		src :components
		((:file "package")
		 (:file "tomb")))))

(asdf:defsystem #:tomb-test
  :description "Test suite for :tomb"
  :author "inaimathi <leo.zovic@gmail.com>"
  :license "MIT Expat"
  :serial t
  :depends-on (#:tomb #:test-utils)
  :defsystem-depends-on (#:prove-asdf)
  :components ((:module
                test :components
                ((:file "package")
                 (:test-file "tomb"))))
  :perform (test-op
	    :after (op c)
	    (funcall (intern #.(string :run) :prove) c)))
