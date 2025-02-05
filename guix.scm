(use-modules
 ((guix licenses) #:prefix license:)
 (gnu packages autotools)
 (gnu packages build-tools)
 (gnu packages file)
 (gnu packages freedesktop)
 (gnu packages gl)
 (gnu packages guile)
 (gnu packages guile-xyz)
 (gnu packages ibus)
 (gnu packages pkg-config)
 (gnu packages pciutils)
 (gnu packages texinfo)
 (gnu packages xml)
 (gnu packages wm)
 (gnu packages xdisorg)
 (gnu packages xorg)
 (gnu packages)
 (guix build-system gnu)
 (guix download)
 (guix gexp)
 (guix git-download)
 (guix packages)
 (guix utils))

(define-public guile-bytestructure-class
  (package
   (name "guile-bytestructure-class")
   (version "0.2.0")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/Z572/guile-bytestructure-class")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "0y3sryy79arp3f5smyxn8w7zra3j4bb0qdpl1p0bld3jicc4s86a"))))
   (build-system gnu-build-system)
   (arguments
    (list #:make-flags #~'("GUILE_AUTO_COMPILE=0")))
   (native-inputs
    (list autoconf
          automake
          pkg-config
          guile-3.0-latest))
   (inputs (list guile-3.0-latest))
   (propagated-inputs (list guile-bytestructures))
   (synopsis "bytestructure and goops")
   (description "This package combines bytestructure with goops,
and provide 4 new bytestructure-descriptor:
bs:unknow, cstring-pointer*, bs:enum, stdbool.")
   (home-page "https://github.com/Z572/guile-bytestructure-class")
   (license license:gpl3+)))

(define-public guile-libinput
  (package
   (name "guile-libinput")
   (version "0.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/Z572/guile-libinput")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "01ldi7sayc5vzy4ia9n8k0xbhdx19yxjscpzf37vr1y825r2ql49"))))
   (build-system gnu-build-system)
   (arguments
    (list #:make-flags #~(list "GUILE_AUTO_COMPILE=0")))
   (native-inputs
    (list autoconf automake
          pkg-config
          guile-3.0-latest))
   (inputs (list guile-3.0-latest libinput))
   (propagated-inputs
    (list
     guile-bytestructure-class
     guile-bytestructures))
   (synopsis "")
   (description "")
   (home-page "")
   (license license:gpl3+)))

(define-public guile-xkbcommon
  (package
   (name "guile-xkbcommon")
   (version "0.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/Z572/guile-xkbcommon")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "1rnvfd7hyff8zngkm15mqfvndk8f11w243fdd373k3cfxfvza69v"))))
   (build-system gnu-build-system)
   (arguments
    (list #:make-flags #~(list "GUILE_AUTO_COMPILE=0")))
   (native-inputs
    (list autoconf automake
          pkg-config
          guile-3.0-latest))
   (inputs (list guile-3.0-latest
                 libxkbcommon
                  ;;; xkbregistry pc file require
                 libxml2))
   (propagated-inputs
    (list
     (primitive-load
      (string-append (dirname (dirname (current-filename)))
                     "/guile-bytestructure-class/guix.scm"))
     guile-bytestructures))
   (synopsis "")
   (description "")
   (home-page "")
   (license license:gpl3+)))

(define guile-wayland
  (package
   (name "guile-wayland")
   (version "0.0.2")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/guile-wayland/guile-wayland")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "0g20rvl540aqb6l4mi62k1mkvgipvvrlr7v40gs5kly450jinvmq"))))
   (build-system gnu-build-system)
   (arguments
    (list
     #:make-flags '(list "GUILE_AUTO_COMPILE=0")
     #:phases
     #~(modify-phases %standard-phases
                      (add-after 'build 'load-extension
                                 (lambda* (#:key outputs #:allow-other-keys)
                                   (substitute* (find-files "." ".*\\.scm")
                                                (("\\(load-extension \"libguile-wayland\" *\"(.*)\"\\)" _ o)
                                                 (string-append
                                                  (object->string
                                                   `(or (false-if-exception
                                                         (load-extension "libguile-wayland" ,o))
                                                        (load-extension
                                                         ,(string-append
                                                           #$output
                                                           "/lib/libguile-wayland.so")
                                                         ,o)))))))))))
   (native-inputs
    (list autoconf
          automake
          libtool
          pkg-config
          texinfo
          guile-3.0-latest))
   (inputs (list guile-3.0-latest wayland wayland-protocols))
   (propagated-inputs
    (list
     guile-bytestructure-class
     guile-bytestructures))
   (synopsis "")
   (description "")
   (home-page "https://github.com/guile-wayland/guile-wayland")
   (license license:gpl3+)))

(define guile-wlroots
  (package
   (name "guile-wlroots")
   (version "0.1")
   (source (local-file "." "guile-wlroots-checkout"
                       #:recursive? #t
                       #:select? (git-predicate (dirname (current-filename)))))
   (build-system gnu-build-system)
   (arguments (list
               #:make-flags '(list "GUILE_AUTO_COMPILE=0")
               #:phases
               #~(modify-phases %standard-phases
                                (add-after 'build 'load-extension
                                           (lambda* (#:key outputs #:allow-other-keys)
                                             (substitute*
                                              (find-files "." ".*\\.scm")
                                              (("\\(load-extension \"libguile-wlroots\" *\"(.*)\"\\)" _ o)
                                               (string-append
                                                (object->string
                                                 `(or (false-if-exception (load-extension "libguile-wlroots" ,o))
                                                      (load-extension
                                                       ,(string-append
                                                         (assoc-ref outputs "out")
                                                         "/lib/libguile-wlroots.so")
                                                       ,o)))))))))))
   (native-inputs
    (list autoconf
          automake
          libtool
          pkg-config
          texinfo
          guile-3.0-latest))
   (inputs (list guile-3.0-latest wlroots))
   (propagated-inputs
    (list guile-bytestructures
          guile-wayland
          guile-bytestructure-class
          guile-xkbcommon
          guile-libinput
          (primitive-load
           (string-append (dirname (dirname (current-filename)))
                          "/util572/guix.scm"))))
   (synopsis "")
   (description "")
   (home-page "")
   (license license:gpl3+)))

guile-wlroots
