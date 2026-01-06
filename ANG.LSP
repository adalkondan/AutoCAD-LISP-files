; this draws ISA as per user specification.
;------------------------------------------
(defun dr(x)
    (* pi (/ x 180.0)))
(defun rd(x)
   (* 180.0 (/ x pi)))
(DEFUN C:ANG(/ A B C D B1 B2 E F G H I J K L M N O)
       (SETVAR "CMDECHO" 0) 
       (SETQ   A (GETPOINT "\n PICK corner point : ")
	           B (GETDIST A "\n        Enter SIZE : ")
			   C (GETDIST A "\n   Enter Thickness : ")
			   D (GETANGLE A "\nRotation angle <0> : "))
	   (COND ((= D NUL) (SETQ D 0))) 
	   (SETQ   B1(- B C)
			   B2(/ C 2)
			   E (POLAR A D B)
			   F (POLAR E (+ D (dr 90)) C)
			   G (POLAR F (+ D (dr 180)) B1) 
			   H (POLAR G (+ D (dr 90)) B1)
			   I (POLAR A (+ D (dr 90)) B)
               J (POLAR F (+ D (dr 270)) B2)
               K (POLAR F (+ D (dr 180)) B2)
               L (POLAR G (+ D (dr 0)) B2)
               M (POLAR G (+ D (dr 90)) B2)			   			   
               N (POLAR H (+ D (dr 270)) B2)
               O (POLAR H (+ D (dr 180)) B2)
	   )		   
	   (COMMAND "OSNAP" "NONE"
	            "PLINE" A "W" "0" "" 
	             E J "A" K "L" L "A" M "L" N "A" O "L" I A ""   
	            "REDRAW"
				"OSNAP" "INTER") 
       (SETVAR "CMDECHO" 1) 
	   (PRINC )
)	   
