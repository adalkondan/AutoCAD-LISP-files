; this draws the 3 views of bolt  at convenient user size and place.
;----------------------------------------------------------06-07-93.
(defun seterr (s)  
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
 (setq *error* oer)
 (setq tlen nil len nil ang nil spt nil)
 (command "osnap" "inter")
 (setvar "blipmode" 1)
 (princ)
)
(DEFUN c:bolt(/ dia hdia spt ang len tlen)
 (setq oer *error* *error*  seterr)
 (setvar "cmdecho" 0) 
 (setq dia (getdist "\n  Enter  Bolt  DIA: ")
       hdia (/ dia 2)) 
 (setvar "blipmode" 0)
 (while (/= (setq view(getstring "\n  Elev / Plan / Side view  E/P/S <exit> : ")) "")
  (cond 
   ((or(= view "E") (= view "e"))
    (progn
     (setq spt (getpoint "\n  PICK neck int.  point: "))
	 (if (= len nil) (setq len (getdist spt "\n  Enter Bolt  LENGTH: ")))
	 (if (= ang nil) (setq ang (getangle spt "\n  Enter Rotation  ANGLE <0>: "))) 
	 (cond ((= ang nul) (setq ang 0)))
	 (command 
	   "osnap" "none"
       "pline" 
          (setq h1 (polar spt (+ ang (/ pi 2)) hdia)) "W" "0" "0" 
          (setq h2 (polar h1 (+ ang pi) (* 0.723 dia))) "A" "S" 
   		  (setq h3 (polar spt (+ ang pi) (* 0.8 dia)))
		  (setq h4 (polar h2 (+ ang (* pi 1.5)) dia)) "L"
		  (setq h5 (polar spt (+ ang (* 1.5 pi)) hdia)) ""
       "pline" h2 "A" "S"
		  (setq h6 (polar h3 (+ ang (/ pi 2)) (* 0.75 dia)))
		  (setq h7 (polar h2 (+ ang (/ pi 2)) hdia)) "L"
		  (setq h8 (polar spt (+ ang (/ pi 2)) dia))
		  (setq h9 (polar spt (+ ang (* pi 1.5)) dia))
		  (setq h10(polar h4 (+ ang (* pi 1.5)) hdia)) "A" "S"
		  (setq h11(polar h3 (+ ang (* pi 1.5)) (* 0.75 dia))) h4 ""
	   "pline" h7 
		  (setq h12 (polar h7 (+ ang pi (/ pi 3)) (* 0.155 dia)))
		  (setq h13 (polar h10 (+ ang (/ (* pi 2) 3)) (* 0.155 dia))) h10 ""
	   "pline" h1 
		  (setq h14 (polar h1 ang len))
		  (setq h15 (polar h14 (+ ang (* pi 1.75)) (* 0.113 dia)))
		  (setq h16 (polar h15 (+ ang (* pi 1.5)) (* 0.84 dia)))
		  (setq h17 (polar h5 ang len)) h5 ""
       "line" h14 h17 ""
     )
     (if (= tlen nil) (progn
	  (while (> (setq tlen(getdist h14 "\n  Threaded Length of bolt : ")) len)
       (princ "\n- Threaded length SHOULD BE LESS than bolt Length -"))))
     (command 
	   "pline" h15 
          (polar h15 (+ ang pi) (+ tlen (* 0.08 dia)))
		  (polar h16 (+ ang pi) (+ tlen (* 0.08 dia))) h16 "" 
	   "osnap" "inter"
     )
    )
   )
   ((or (= view "P") (= view "p")) 
	(progn 
	 (setq spt(getpoint "\n  PICK neck int.  point: "))
	 (if (= len nil) (setq len(getdist spt "\n  Enter Bolt  LENGTH: ")))
	 (if (= ang nil) (setq ang(getangle spt "\n  Enter Rotation  ANGLE <0>: "))) 
	 (cond ((= ang nul) (setq ang 0)))
	 (setq h1 (polar spt (+ ang (/ pi 2)) hdia)
		   h5 (polar h1 (+ ang (* pi 1.5)) dia)
		   hd (* 1.732 dia))
	 (command 
       "osnap" "none"
	   "pline" spt (setq p1 (polar spt (+ ang (/ pi 2)) (/ hd 2)))
			        (setq p2 (polar p1 (+ ang pi) (* 0.8 dia)))
			        (setq p3 (polar p2 (+ ang (* pi 1.5)) hd))
			        (setq p4 (polar p3 ang (* 0.8 dia))) "C" 
       "pline" (setq p5 (polar p1 (+ ang pi) (* 0.723 dia))) "A" "S"
               (setq p6 (polar p2 (+ ang (* pi 1.5)) (/ hd 4)))
               (setq p7 (polar p5 (+ ang (* pi 1.5)) (/ hd 2))) ""
       "copy" "L" "" p5 p7         
       "line" p7 spt ""
       "pline" h1 (setq h14 (polar h1 ang len))
		 	      (setq h15 (polar h14 (+ ang (* pi 1.75)) (* 0.113 dia)))
			      (setq h16 (polar h15 (+ ang (* pi 1.5)) (* 0.84 dia)))
			      (setq h17 (polar h5 ang len)) h5 ""
     )
     (if (= tlen nil) (progn
      (while (> (setq tlen(getdist h14 "\n  Threaded Length of bolt : ")) len)
       (princ "\n- Threaded length SHOULD BE LESS than bolt Length -"))))
	 (command  
	   "pline" h15 
                  (polar h15 (+ ang pi) (+ tlen (* 0.08 dia)))
		          (polar h16 (+ ang pi) (+ tlen (* 0.08 dia))) h16 ""
	   "line" h14 h17 ""
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
)			