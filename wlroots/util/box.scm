(define-module (wlroots util box)
  #:use-module (util572 box)
  #:use-module (wlroots types)
  #:use-module (wayland util)
  #:use-module (oop goops)
  #:use-module (bytestructures guile)
  #:export (%wlr-box-struct %wlr-fbox-struct <wlr-box> make-wlr-box list->wlr-box))
(define %wlr-box-struct
  (bs:struct `((x ,int) (y ,int) (width ,int) (height ,int))))

(define %wlr-fbox-struct
  (bs:struct `((x ,double)
               (y ,double)
               (width ,double)
               (height ,double))))

(define-wlr-types-class-public wlr-box (<box>)
  (x #:allocation #:virtual
     #:slot-ref
     (lambda (box) (bytestructure-ref (->bytestructure box) 'x))
     #:slot-set!
     (lambda (box n) (bytestructure-set! (->bytestructure box) 'x n))
     #:accessor box-x)
  (y #:allocation #:virtual
     #:slot-ref
     (lambda (box) (bytestructure-ref (->bytestructure box) 'y))
     #:slot-set!
     (lambda (box n) (bytestructure-set! (->bytestructure box) 'y n))
     #:accessor box-y)
  (height #:allocation #:virtual
          #:slot-ref
          (lambda (box) (bytestructure-ref (->bytestructure box) 'height))
          #:slot-set!
          (lambda (box n) (bytestructure-set! (->bytestructure box) 'height n))
          #:accessor box-height)
  (width #:allocation #:virtual
         #:slot-ref
         (lambda (box) (bytestructure-ref (->bytestructure box) 'width))
         #:slot-set!
         (lambda (box n) (bytestructure-set! (->bytestructure box) 'width n))
         #:accessor box-width))
(define (make-wlr-box x y width height)
  (wrap-wlr-box (bytestructure->pointer
                 (bytestructure
                  %wlr-box-struct
                  `((x ,x)
                    (y ,y)
                    (width ,width)
                    (height ,height))))))

(define-method (shallow-clone (box <wlr-box>))
  (make-wlr-box (box-x box) (box-y box) (box-width box) (box-height box)))
(define (list->wlr-box l)
  (apply make-wlr-box l))

(define-method (->bytestructure (box <wlr-box>))
  (pointer->bytestructure (get-pointer box) %wlr-box-struct))
