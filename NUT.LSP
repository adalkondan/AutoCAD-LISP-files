; this draws the 3 views of nut  at convenient user size and place.
;---------------------------------------------------------06-07-93.
(defun dr(x)
    (* pi (/ x 180.0)))
(defun rd(x)
    (* 180.0 (/ x pi)))
(defun seterr (s)  
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
 (setq *error* oer)
 (setq ang nil spt nil)
 (command "osnap" "inter")
 (princ)
)
(DEFUN c:nut(/ dia spt ang)
 (setq oer *error* *error*  seterr)
 (setvar "cmdecho" 0) 
 (setq dia (getdist "\n Enter  dia of Bolt : ")
       hdia (/ dia 2)) 
 (setvar "blipmode" 0)
 (while (/= (setq view(getstring "\n  Elev / Plan / Side view  E/P/S <exit> : ")) "")
  (cond 
   ((or(= view "E") (= view "e"))
    (progn
     (setq spt (getpoint "\n  PICK (bolt side) neck int.  point: "))
	 (if (= ang nil) (setq ang (getangle spt "\n  Enter Rotation  ANGLE <0>: "))) 
	 (cond ((= ang nul) (setq ang 0)))
     (setq a1 (polar spt ang (* 0.077 dia))
           a3 (polar spt ang dia)
		   a2 (polar a3 (+ ang (dr 180)) (* 0.077 dia))
		   n1 (polar spt (+ ang (dr 90)) (* 0.866 dia))
		   n2 (polar a1 (+ ang (dr 90)) dia)  
           n3 (polar a2 (+ ang (dr 90)) dia)
           n4 (polar n1 ang dia) 
           n5 (polar a3 (+ ang (dr 270)) (* 0.866 dia))
		   n6 (polar a2 (+ ang (dr 270)) dia)
		   n7 (polar a1 (+ ang (dr 270)) dia)
		   n8 (polar n5 (+ ang (dr 180)) dia)
		   a4 (polar a3 (+ ang (dr 90)) (* 0.75 dia))
           a5 (polar a2 (+ ang (dr 90)) hdia)
		   a6 (polar a5 (+ ang (dr 270)) dia)
		   a7 (polar a3 (+ ang (dr 270)) (* 0.75 dia))
		   a8 (polar spt (+ ang (dr 90)) (* 0.75 dia))
		   a9 (polar a1 (+ ang (dr 90)) hdia)
           a10(polar a9 (+ ang (dr 270)) dia)
		   a11(polar spt (+ ang (dr 270)) (* 0.75 dia))
	 )		
     (command 
	   "osnap" "none"
	   "pline" spt "W" "0" "" n1 n2 n3 n4 n5 n6 n7 n8 "C"
	   "pline" n2 "A" "S" a8 a9 "S" spt a10 "S" a11 n7 ""
	   "Pline" n3 "A" "S" a4 a5 "S" a3 a6 "S" a7 n6 ""
	   "line" a9 a5 ""  "line" a10 a6 ""
	   "osnap" "inter"
     )
    )
   )
   ((or (= view "P") (= view "p")) 
	(progn 
	 (setq spt(getpoint "\n PICK (bolt side) neck int. point: ")
	        hd(* 1.732 dia))
	 (if (= ang nil) (setq ang(getangle spt "\n  Enter Rotation  ANGLE <0>: "))) 
	 (cond ((= ang nul) (setq ang 0)))
     (setq n1 (polar spt (+ ang (dr 90)) (/ hd 2))
	       n2 (polar n1 ang dia)
		   n3 (polar n2 (+ ang (dr 270)) hd)
		   n4 (polar n3 (+ ang (dr 180)) dia)
	       a1 (polar spt ang (* 0.077 dia))
           a3 (polar spt ang dia)
		   a2 (polar a3 (+ ang (dr 180)) (* 0.077 dia))
           a4 (polar a2 (+ ang (dr 90)) (/ hd 2))
		   a5 (polar a3 (+ ang (dr 90)) hdia)
		   a6 (polar a5 (+ ang (dr 270)) dia)
		   a7 (polar a4 (+ ang (dr 270)) hd)
		   a8 (polar a1 (+ ang (dr 90)) (/ hd 2))
		   a9 (polar a5 (+ ang (dr 180)) dia)
		   a10(polar a6 (+ ang (dr 180)) dia)
		   a11(polar a1 (+ ang (dr 270)) (/ hd 2))
     )
	 (command "osnap" "none"
	          "pline" spt "W" "0" "" n1 n2 n3 n4 "C"
			  "pline" a8 "A" "S" a9 a1 "S" a10 a11 ""
			  "pline" a4 "A" "S" a5 a2 "S" a6 a7 ""
	          "line" a1 a2 ""
			  "osnap" "inter"
	 )
	)
   )
   ((or (= view "S") (= view "s"))
	(progn 
	 (setq spt(getpoint "\n  PICK head centre  point: "))
	 (command "osnap" "none"
			  "polygon" "6" spt "I" dia
              "circle" spt (* dia 0.866)
              "circle" spt hdia
			  "osnap" "inter"
	 )
    )
   )
  )
 )
 (setq *error* oer)
 (setvar "cmdecho" 1)
 (setvar "blipmode" 1)
 (princ)			
)			

