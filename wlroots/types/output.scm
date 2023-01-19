(define-module (wlroots types output)
  #:use-module ((system foreign)
                #:select ((uint32 . ffi:uint32)
                          (float . ffi:float)
                          (int . ffi:int)
                          (void . ffi:void)))
  #:use-module (wlroots render allocator)
  #:use-module (wlroots render renderer)
  #:use-module (wlroots backend)
  #:use-module (wlroots util addon)
  #:use-module (wlroots types)
  #:use-module (wlroots utils)
  #:use-module (wayland util)
  #:use-module (wayland listener)
  #:use-module (oop goops)
  #:use-module (wayland list)
  #:use-module (srfi srfi-26)
  #:use-module (wayland signal)
  #:use-module (bytestructures guile)
  #:re-export (%wlr-output-state-struct
               %wlr-output-struct)
  #:export (wrap-wlr-output
            unwrap-wlr-output
            wlr-output-init-render
            .modes
            <wlr-output>
            wlr-output-preferred-mode
            wlr-output-set-mode
            wlr-output-enable
            wlr-output-commit
            wlr-output-modes
            wlr-output-enable-adaptive-sync

            <wlr-output-cursor>
            wrap-wlr-output-cursor
            unwrap-wlr-output-cursor
            .adaptive-sync-status
            .allocator
            .backend
            .current-mode
            .data
            .description
            .display
            .enabled
            .height
            .name
            .needs-frame
            .non-desktop
            .phys-height
            .phys-width
            .refresh
            .renderer
            .scale
            .subpixel
            .transform
            .width))

(define-wlr-types-class wlr-output ()
  (backend      #:accessor .backend)
  (display      #:accessor .display)
  (name         #:accessor .name)
  (description  #:accessor .description)
  (phys-width   #:accessor .phys-width)
  (phys-height  #:accessor .phys-height)
  (current-mode #:accessor .current-mode)
  (width        #:accessor .width)
  (height       #:accessor .height)
  (refresh      #:accessor .refresh)
  (enabled      #:accessor .enabled)
  (scale        #:accessor .scale)
  (subpixel     #:accessor .subpixel)
  (transform    #:accessor .transform)
  (adaptive-sync-status #:accessor .adaptive-sync-status)

  (needs-frame #:accessor .needs-frame)
  (non-desktop  #:accessor .non-desktop)
  (allocator #:accessor .allocator)
  (renderer #:accessor .renderer)
  (data         #:accessor .data)
  #:descriptor %wlr-output-struct)

(eval-when (expand load eval)
  (load-extension "libguile-wlroots" "scm_init_wlr_output"))

(define-wlr-types-class wlr-output-mode ()
  #:descriptor %wlr-output-mode-struct)

(define (wlr-output-modes o)
  (wrap-wl-list (%wlr-output-modes o)))

(define .modes wlr-output-modes)

(define wlr-output-init-render
  (let ((proc (wlr->procedure ffi:int "wlr_output_init_render" '(* * *))))
    (lambda (output allocator renderer)
      (proc (unwrap-wlr-output output)
            (unwrap-wlr-allocator allocator)
            (unwrap-wlr-renderer renderer)))))
(define-wlr-procedure (wlr-output-preferred-mode output)
  ('* "wlr_output_preferred_mode" '(*))
  (wrap-wlr-output-mode (% (unwrap-wlr-output output))))

(define-wlr-procedure (wlr-output-set-mode output mode)
  (ffi:void "wlr_output_set_mode" '(* *) )
  (% (unwrap-wlr-output output) (unwrap-wlr-output-mode mode)))

(define-wlr-procedure (wlr-output-enable-adaptive-sync output enabled)
  (ffi:void "wlr_output_enable_adaptive_sync" (list '* ffi:int))
  (% (unwrap-wlr-output output) (if enabled 1 0)))

(define-wlr-procedure (wlr-output-enable output enable)
  (ffi:void "wlr_output_enable" (list '* ffi:int))
  (% (unwrap-wlr-output output) (if enable 1 0)))

(define-wlr-procedure (wlr-output-commit output)
  (ffi:int "wlr_output_commit" '(*))
  (case (% (unwrap-wlr-output output))
    ((1) #t)
    ((0) #f)
    (else #t)))

(define-wlr-types-class wlr-output-cursor ()
  (x #:accessor .x)
  (y #:accessor .y)
  (enabled #:accessor .enabled)
  (visible #:accessor .visible)
  (width #:accessor .width)
  (height #:accessor .height)
  (hostpot-x #:accessor .hostpot-x)
  (hostpot-y #:accessor .hostpot-y)
  (surface #:accessor .surface)
  #:descriptor %wlr-output-cursor-struct)
