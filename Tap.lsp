(Defun C:TAP ()
    (setq pbs (getvar "pickbox")
	      aps (getvar "aperture")
		  osm (getvar "osmode"))
	(setvar "pickbox" 3) (setvar "aperture" 4) (setvar "osmode" 32)	 
	(setvar "cmdecho" 0) (setvar "blipmode" 0)
	   (setq p1  (Getpoint "\n START POINT OF TAP :")
	         dia (Getdist p1 "\n ENTER TAP Dia. :")
	         ang (Getreal "\n ENTER ROTATION ANGLE OF TAP <0> :")
	   )
	(setvar "osmode" 0)
	   (If (or (= ang nul) (= ang 0)) (setq ang 0))
	   (setq p2 (polar p1 pi (/ dia 2))
	         p3 (polar p2 (* pi 1.5) (* dia 2))
			 p4 (polar p1 (* pi 1.5) (* dia 2))
			 p5 (polar p1 (* pi 1.5) (* dia 0.0577))
			 p6 (polar p5 pi (* dia 0.4))
			 p8 (polar p1 (* pi 1.5) (* dia 2.5))
			 p7 (polar p8 pi (* dia 0.4))
			 p9 (polar p8 (* pi 1.5) (* dia 0.2309))
			 p10 (polar p9 0 (/ dia 2))
		)
		(command "line"  p2 p3 p4 "" "line" p5 p6 p7 p8 ""
		         "line" p7 p9 "" "line" p2 p6 ""
				 "mirror" "w" p2 p9 "" "nea" p1 p9"")
		(If (not (= ang 0)) (command "rotate" "w" p2 p10 "" p1 ang))
		(print) (print) (princ "--TAP-DRAWN--") (PRINC)
	(setvar "pickbox" pbs) (setvar "aperture" aps) (setvar "osmode" osm)	 
	(setvar "cmdecho" 1) (setvar "blipmode" 1)
)				  
				 
				  
				  
				  	  