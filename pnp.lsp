;; utilise basu's help to insert part nos continuously & perfectly
;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;user can insert part no with ballons to present scale, (on xt layer)
;;inserting can be single or many. ballon can accomodate two nos.
;;
;;
(defun dr(x)
    (* pi (/ x 180.0)))
(defun rd(x)
    (* 180.0 (/ x pi)))
;-------------------------------------------------------------------
(defun c:pnp(/ SCALE START)
 (IF (= PNB NIL) (SETQ PNB 1)) 
 (setvar "cmdecho" 0)
 (setvar "attreq" 1)
 (setvar "attdia" 0)
 (setq scale (getvar "userr1") 
       lay   (getvar "clayer")
       osm   (getvar "osmode")
       start "Y" pnbo pnb
	   ts    (tblsearch "LAYER" "PN1"))
 (if (null ts)
    (prompt "\nCreating new layer - PN1. ")
    (progn
     (if (= (logand 1 (cdr (assoc 70 ts))) 1)
         (progn
          (prompt "\nLayer PN1 is frozen. ")
          (initget  "Yes No")
          (setq xx (getkword "\nProceed? <N>: "))
          (if (= xx "Yes")
              (command "LAYER" "T" "PN1" "")
          )
         )
     )
    )
 )
 (command "layer" "m" "PN1" "c" "130" "" "")
 (princ "\n Present scale - ") (princ scale)
 (cond ((= scale 0.0) 
       (setq scale  (getreal "\nEnter SCALE of drawing : ")
             scale_y(getstring "\n Store SCALE < N >: "))
        (IF (or (= scale_y "y") (= scale_y "Y"))
            (setvar "userr1" scale))))
 (princ "\n Enter start PART No < ") (princ pnb) 
 (setq pnb(getint " > : ")) 
 (cond ((= pnb nul) (setq pnb pnbo)))
 (setvar "blipmode" 1)
 (while (= start "Y")

  (setq  pt1(getpoint  "\n Pick Location.."))
;
;         pt2(getpoint "\n Pick Leader end..")
;         ang(angle pt1 pt2)
;         ang(rd ang))
;  (if    (or (< ang 90) (> ang 270))
;         (command "LEADER" pt1 pt2 "" "" "b" 
;                  "pn" pt2 scale "" "0" pnb)
;         (command "LEADER" pt1 pt2 ""  "" "b"
;                  "pnl" pt2 scale "" "0" pnb))
;
  (command "insert" "pnp" pt1 scale "" "0" pnb)

  (setq pnbo pnb pnb(1+ pnb))
  (initget "Y N")
  (setq start(getkword "\n Print next <Y> : "))
  (if (= start nul) (setq start "Y"))
 )
 (setvar "clayer" lay)
 (c:normal)
 (princ)
)
