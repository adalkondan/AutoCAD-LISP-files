;
;     Copyright (C) 1991-92 by Autodesk, Inc.
;
;     Permission to use, copy, modify, and distribute this software 
;     for any purpose and without fee is hereby granted, provided 
;     that the above copyright notice appears in all copies and that 
;     both that copyright notice and this permission notice appear in 
;     all supporting documentation.
;
;     THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED
;     WARRANTY.  ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR
;     PURPOSE AND OF MERCHANTABILITY ARE HEREBY DISCLAIMED.
;     ****************************************************************
;    VSCALE.LSP
;    find the scale of a viewport relative to paper space
;    Carl Bethea  11 April 91
;
;
;--- paper -------------------------------------------------
; returns T if in paper space
(defun paper ()
   (> 2 (getvar "cvport")(getvar "tilemode")) ; port=1 & tile=0
)
;
;--- getx --------------------------------------------------
; return <nth> dotted pair of the extended entity data
; from an entity association list <data>
;
(defun getx (n data)
(nth n (cdadr (assoc -3 data)))
)
;
;
;--- sslist -----------------------------------------------
; convert selection-set <SS> into a list of entities <P>
; result is the list <P>
; Example: (sslist <selection-set>)
;
(defun sslist (SS / N P)
(repeat (setq N (sslength SS))      ;seed N
   (setq N (1- N)                   ;index number
         P (cons (ssname SS N) P))  ;setq
);repeat
); sslist
;
;
;--- findvp ------------------------------------------------
; find viewport data of current viewport
;
(defun findvp (vp# / vplist)
(setq vplist (ssget "X" '((0 . "viewport")))
      vplist (sslist vplist)
)
(while 
    (and (/= (dxf 69) vp#) 
         (setq ent (car vplist))
    )
    (setq data (entget ent)
        vplist (cdr vplist)
	
    )
);while
ent
)
; 
;--- c:vscale ----------------------------------------------
; get the xp scale factor of a pspace viewport
;
(defun c:vscale (/ dxf ent data cvsize cvhgt)
   (defun dxf (code)(cdr(assoc code data)))
(if (paper)
   (setq ent (car (entsel "\nSelect edge of viewport: ")))
   (setq ent (findvp (getvar "cvport"))) 
)
(cond
((and 
      ent
      (setq data (entget ent '("ACAD")))
      (= "VIEWPORT" (dxf 0))
 );and
   (setq cvhgt (dxf 41)  ; viewport height
        cvsize (cdr (getx 6 data))    ; viewsize from extended data
   )
   (prompt "\nPS:MS == ") 
   (cond 
   ((< cvsize cvhgt)
      (princ (rtos (/ cvhgt cvsize)))
      (princ (strcat ":" (rtos 1)))
   )
   (T (princ (strcat (rtos 1)  ":"))
      (princ (rtos (/ cvsize cvhgt)))
   )
   );cond
)
(T (prompt " no viewport found."))
);cond
(princ)
);c:vscale
;
