; COUNT.LSP   Copyright 1991   Tony Tanzillo   All Rights Reserved.
; -----------------------------------------------------------------
;
; Adds the COUNT command to AutoCAD, which counts, itemizes, and displays
; in tabular form, the number of insertions of each block in the selected
; objects, or the entire drawing.
;
; Add to ACAD.LSP, or load with (load"count")
;
; First implemented in May of 1990.
;
; Revision history:
;
; 10/13/1991:  General revisions for R11:
;
;              1.  Now ignores anonymous blocks and Xrefs.
;
;              2.  Added console/screen paging, pauses listing
;                  at each screen-full and waits for a keypress.
;
;    Notes on console paging:
;
;      1.  To disable console paging, add the following to COUNT.LSP:
;
;              (setq *cpage-disable* t)
;
;      2.  The number of physical console lines defaults to 25.  This
;          can be overridden by adding the following to COUNT.LSP
;
;              (setq *console-lines* <num> )
;
;          Where <num> is the integer number of physical screen lines.
;
;      3.  The screen-clear function defaults to (textpage) under R11,
;          and (textscr) under R10 (no screen-clearing is performed),
;          but it can be redefined by assigning a function that is to
;          be called to do a screen-clear to the symbol *clear-screen*.
;
;          The following example can be used with R10 if ANSI.SYS or
;          any compatible console-driver is installed, to clear the
;          display on each screen-page:
;
;               (defun *clear-screen* ()
;                  (textscr)
;                  (princ "\e[2J")
;                  nil
;               )
;
; Program listing:

 (defun C:COUNT ( / blocks ss)
    (princ "\nPress <CR> to select entire drawing or,")
    (cond
       (  (not (setq ss (cond ((ssget))
                              (t (ssget "x" '((0 . "INSERT")))))))
          (princ "\nNo objects selected."))
       (t (princ "\nCounting block insertions...")
          (  (lambda (i)
                (repeat i (count_block (ssname ss (setq i (1- i))))))
             (sslength ss))
          (cond
             (  (not blocks)
                (princ "\nNo block insertions found."))
             (t (table-print blocks "Block" "Count" "-" 8 "." nil 'itoa)))))
    (princ)
 )

 (defun table-print (alist title1 title2 headsub coltab padchr
                     car-form cdr-form / maxlen maxline padstr )
    (setq car-form (cond (car-form) (t '(lambda (x) x)))
          cdr-form (cond (cdr-form) (t '(lambda (x) x))))
    (setq maxlen
       (mapcar
         '(lambda (pair)
             (cons (strlen (car pair))
                   (strlen (cdr pair))))
          (setq alist
             (mapcar
               '(lambda (pair)
                   (cons (apply car-form (list (car pair)))
                         (apply cdr-form (list (cdr pair)))))
                alist ))))
    (setq maxlen  (+ -2 (apply 'max (mapcar 'car maxlen))
                        (apply 'max (mapcar 'cdr maxlen)))
          maxline (+ maxlen coltab)
          padstr  (repl padchr 70))

    (cprinc-init)
    (cprinc (strcat title1 " "
                    (ctab (cons title1 title2)
                          maxline
                          (repl " " 70))
                    " " title2))
    (cprinc (repl headsub (+ maxline 2)))
    (mapcar
      '(lambda (pair)
          (cprinc (strcat (car pair) " "
                          (ctab pair maxline padstr) " "
                          (cdr pair))))
       alist )
 )

 (defun repl (chr len / res)
    (apply 'strcat (repeat len (setq res (cons chr res))))
 )

 (defun ctab (pair max padstr)
    (substr padstr 1 (- max (strlen (car pair) (cdr pair))))
 )

 (defun cdr++ (key alist)
    (  (lambda (x)
          (cond (x (subst (cons (car x) (1+ (cdr x))) x alist))
                (t (cons (cons key 1) alist))))
       (assoc key alist))
 )

 (defun get (k l) (cdr (assoc k l)))

 (defun entgetf (k e)
    (  (lambda (l)
          (mapcar '(lambda (x) (cdr (assoc x l))) k))
       (entget e))
 )

 (defun count_block (ename)
    (apply
      '(lambda (etype name)
          (cond
             (  (and (eq "INSERT" etype)
                     (or (assoc name blocks)
                         (zerop (logand 45 (get 70 (tblsearch "block" name)))))
                (setq blocks (cdr++ name blocks))))) nil)
       (entgetf '(0 2) ename))
 )

 (defun cprinc-init ()
    (setq *console-lines* (cond (*console-lines*) (t 25))
          *cprinc-msg* (cond (*cprinc-msg*) (t "--- Press any key ---"))
          *cprinc-rubout*
          (cond (  (or textpage *clear-screen*) "")
                (t (strcat "\r" (repl " " (strlen *cprinc-msg*)) "\r")))
          *cprinc-line* -1)
    (cond (textpage (textpage))
          (*clear-screen* (*clear-screen*))
          (t (textscr) (terpri)))
 )

 (defun cprinc-page ()
    (princ *cprinc-msg*)
    (grread)
    (cond (textpage (textpage))
          (*clear-screen* (*clear-screen*))
          (t (textscr)))
    (princ *cprinc-rubout*)
    (setq *cprinc-line* 0)
 )

 (defun cprinc (s)
    (cond (  *cpage-disable*)
          (  (not *cprinc-line*)
             (cprinc-init))
          (  (eq (setq *cprinc-line* (1+ *cprinc-line*))
                 (1- *console-lines*))
             (cprinc-page)))
    (write-line s)
 )

; ############################ eof COUNT.LSP ################################

(princ "\nC:COUNT loaded.  Start command with COUNT. ")
(princ)
