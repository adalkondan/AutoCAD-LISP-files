;THIS PROGRAM DRAWS BASE PLATE & HOLES BY GIVING SPACING
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>basu
(defun dr(x)
	(* pi (/ x 180.0)))
(defun rd(x)
    (* 180 (/ x pi)))
(defun C:BPH(/ SP SPB OS A C B D PDS)
 (setvar "cmdecho" 0) 
 (setvar "pdmode" 2)
 (setvar "blipmode" 1)
 (setq HD    (getdist"\n Enter HOLE DIA : ")
       HT HTO W WO  
       SP (getpoint "\n Pick CENTRE point of Rectangle : "))
 (PRINC "\n Enter Height of Rectangle < ") (princ HT)
 (setq HT (getdist  " > : "))
 (cond ((= HT nul) (setq HT HTO)))
 (princ "\n Enter Width of Rectangle < ") (princ W)
 (setq W (getdist  " > : "))
 (cond ((= W nul) (setq W WO)))
 (cond ((= ANG nil) (setq ANG 0)))
 (princ "\n Rotation angle < ") (princ (rtos (rd ANG)))
 (setq ang (getangle  " > : "))
 (cond ((= ANG nul) (setq ANG ANGO)))
 (cond ((= ANG nil) (setq ANG 0)))
 (while SP
  (setq SPB (polar SP (+ ANG (dr 270)) (/ HT 2))
        A   (polar SPB (+ ANG pi) (/ W 2))
        C   (polar A ANG W)
	B   (polar A (+ ANG (dr 90)) HT)
	D   (polar B ANG W)
	HTO HT WO W ANGO ANG)
  (command "osnap" "none" "point" sp 
           "circle" A "d" hd
           "circle" B "d" hd
           "circle" C "d" hd
           "circle" D "d" hd )
  (setq  SP (getpoint "\n Pick next CENTER point of Rectangle <exit> : "))
 )
 (c:normal)
 (princ)
)