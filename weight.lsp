; jan- 1993 - Basu
;-----------------------------
(vmon)
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun dr(x)
    (* pi (/ x 180.0)))
(defun rd(x)
    (* 180.0 (/ x pi)))
;----------------------------------------------------
(apply '(lambda ()
(textscr)
(princ "\n          .. FORMULAs. for ..")
(princ "\n")
(princ "\n   wta = weight of std. Angles.")
(princ "\n   wtb = weight of std. Beams.")
(princ "\n   wtc = weight of std. Channels.")
(princ "\n   wtd = weight by dimensions / area. ")
(princ "\n  wtcy = wt.  of Cylinder.")
(princ "\n wtcy1 = wt.  of Hollow cylinder.")
(princ "\n  wtsp = wt.  of Sphere.")
(princ "\n wtsp1 = wt.  of sphere segment.")
(princ "\n wtsp2 = wt.  of sphere sector.")
(princ "\n wtsp3 = wt.  of spherical zone.") 
(princ "\n wtsp4 = wt.  of hollow sphere.")
(princ "\n  wtco = weight of cone.")
(princ "\n wtco1 = weight of frustum of cone.")
(princ "\n  wtpr = wt.  of any shaped base Prism.")
(princ "\n  wtpy = wt.  of any shaped base Pyramid.")
(princ "\n wtpy1 = wt.  of frustum of pyramid.")
(princ "\n  wtbo = wt.  of Bolt Nut assy.")
(PRINC "\n")
(PROMPT "\n....CALL BY NAME..  (eg..WTC, WTCO1. etc).")
(princ)) '()
) 
;
(defun c:wta (/ wa wb n wc wct wtm)
 (setq oer *error*
       *error*  seterr)
 (initget "40 45 50 60 65 75 90 100 110 150")
 (setq wa (getkword "\n
  isa  40 x 40 x 6  - 3.5 kg/m
  isa  45 x 45 x 6  - 4.0 kg/m
  isa  50 x 50 x 6  - 4.5 kg/m
  isa  60 x 60 x 6  - 5.4 kg/m
  isa  65 x 65 x 8  - 7.7 kg/m
  isa  75 x 75 x 8  - 8.9 kg/m
  isa  75 x 75 x10  -11.0 kg/m
  isa  90 x 90 x10  -13.4 kg/m
  isa 100 x100 x10  -14.9 kg/m
  isa 110 x110 x12  -19.6 kg/m
  isa 150 x150 x15  -33.6 kg/m 
  \n   Select ANGLE section -
 	< 40,45,50,60,65,75,90,100,110 or 150 >: "))
 (cond ((= wa "40") (setq wtm  3.5 )))
 (cond ((= wa "45") (setq wtm  4.0 )))
 (cond ((= wa "50") (setq wtm  4.5 )))
 (cond ((= wa "60") (setq wtm  5.4 )))
 (cond ((= wa "65") (setq wtm  7.7 )))
 (cond ((= wa "75") (setq wtm  8.9 )))
 (cond ((= wa "90") (setq wtm  13.4 )))
 (cond ((= wa "100") (setq wtm  14.9 )))
 (cond ((= wa "110") (setq wtm  19.6 )))
 (cond ((= wa "150") (setq wtm  33.6 )))
 (cond ((/= wa nul) (setq wb (getdist "\nEnter Length of section - <mm> : "))))
 (while (/= wb nil)
  (setq  wb(/ wb 1000.0) wc(* wtm wb))
  (setq n  (getint  "\n               No. off - < 1 > : "))
  (cond ((= n nul) (setq n 1)))
  (princ "\n              Member Weight is = ") 
  (princ wc) 
  (cond ((> n 1) 
         (progn
          (setq wct(* wc n))
          (princ " x ") 
          (princ n) 
          (princ " = ") 
          (princ wct)
         )
        )
  )
  (princ " kgs.")
  (setq wb (getdist "\n Next Length of section - <mm> : "))
 )
 (princ)
)
;
; to calculate weight of all bolt assly. elements togather.
;----------------------------------------------------------
(defun seterr (s)  
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 ) (setvar "cmdecho" 1)
 (princ)
)
(DEFUN C:WTBO(/ BT BD BL WAS WASTH R R1 WTB WTH WTW  BA) 
 (setvar "cmdecho" 0)
 (SETQ D(GETREAL "\n     Enter Bolt Dia....")
       R (/ D 2.0)
	   L(GETREAL "\n     Give LENGTH.......")
       L(- L D)
	  WTB(/ (* PI L 7.85 (* R R)) 1000000.0))
  (SETQ BT "h")
; (INITGET  "s S h H")
; (SETQ BT (GETKWORD "\n TYPE Hex / Sqr <H>...."))
 (COND ((OR (= BT NUL) (= BT "H") (= BT "h"))
            (SETQ AREA(* 2.598 D D)))
       ((OR (= BT "s") (= BT "S"))
            (SETQ AREA(* 0.5 (* 5.0 BD BD)))))
 (SETQ WTH(/ (* AREA D 7.85 0.8) 1000000.0))
 (SETQ WTN(/ (* AREA D 7.85) 1000000.0))
 (PRINC "\n(.enter 0 for no washer.)")
 (INITGET  "0 1 2 3 4 5 6 7 8 9")
 (SETQ WAS(GETINT "\nNo.off Washers  <1>...."))		 
 (COND ((= WAS 0) (SETQ WTW 0))
       ((OR (= WAS NUL) (= WAS 1)) 
            (PROGN
             (SETQ WASTH (GETREAL "\nGive Washer thk.<3>...."))
             (IF (= WASTH NUL) (SETQ WASTH 3))      
		     (SETQ R1  (* D 1.2 0.5)
	               R   (* D 2.2 0.5)
                   WTW (/ (* pi WASTH 7.85 (- (* R R) (* R1 R1))) 1000000.0))))
        ((> WAS 1)
		 (PROGN
		  (SETQ WASTH (GETREAL "\nGive Washer thk.<3>...."))
            (IF (NOT WASTH) (SETQ WASTH 3))      
		    (SETQ R1  (* D 1.2 0.5)
	              R   (* D 2.2 0.5)
                  WTW (/ (* pi WASTH WAS 7.85 (- (* R R) (* R1 R1))) 1000000.0)))))
 (SETQ WTT(+ WTH WTB WTW WTN))
 (SETQ BA(GETINT  "\n       HOW MANY <1>...."))
 (PRINC "\n Weight of Bolt Nut assly. = ") (princ WTT)
 (COND ((AND (/= BA NIL) (> BA 1)) 
             (PROGN
               (SETQ WTBA(* WTT BA))
			   (PRINC " x ") (PRINC BA) (PRINC " = ") (PRINC WTBA))))
 (PRINC "  kgs.") 
 (setvar "cmdecho" 1)
 (PRINC)
)
;
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(vmon)
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun c:wtc (/ wa wb n wc wct wtm)
 (setq oer *error*
       *error*  seterr)
 (initget "75 100 125 150 175 200 225 250 300 350 400")
 (setq wa (getkword "\n
  ismc  75x 40 - 6.8 kg/m
  ismc 100x 50 - 9.2 kg/m 
  ismc 125x 65 -12.7 kg/m 
  ismc 150x 75 -16.4 kg/m 
  ismc 175x 75 -19.1 kg/m 
  ismc 200x 75 -22.1 kg/m
  ismc 225x 80 -25.9 kg/m 
  ismc 250x 80 -30.4 kg/m 
  ismc 300x 90 -35.8 kg/m 
  ismc 350x100 -42.1 kg/m 
  ismc 400x100 -49.4 kg/m
  \n   Select CHANNEL section -
 	< 75,100,125,150,175,200,225,250,300,350 or 400 > : "))
 (cond ((= wa "75") (setq wtm 6.8)))
 (cond ((= wa "100") (setq wtm 9.2)))
 (cond ((= wa "125") (setq wtm 12.7)))
 (cond ((= wa "150") (setq wtm 16.4)))
 (cond ((= wa "175") (setq wtm 19.1)))
 (cond ((= wa "200") (setq wtm 22.1)))
 (cond ((= wa "225") (setq wtm 25.9)))
 (cond ((= wa "250") (setq wtm 30.4)))
 (cond ((= wa "300") (setq wtm 35.8)))
 (cond ((= wa "350") (setq wtm 42.1)))
 (cond ((= wa "400") (setq wtm 49.4)))
 (cond ((/= wa nul) (setq wb (getdist "\nEnter Length of section - <mm> : "))))
 (while (/= wb nil)
  (setq  wb(/ wb 1000.0) wc(* wtm wb))
  (setq n  (getint  "\n               No. off - < 1 > : "))
  (cond ((= n nul) (setq n 1)))
  (princ "\n              Member Weight is = ") 
  (princ wc) 
  (cond ((> n 1) 
         (progn
          (setq wct(* wc n))
          (princ " x ") 
          (princ n) 
          (princ " = ") 
          (princ wct)
         )
        )
  )
  (princ " kgs.")
  (setq wb (getdist "\n Next Length of section - <mm> : "))
 )
 (princ)
)

;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:WTCO (/ r d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
   (setq r(getdist "\n-mm-    Give base radius : "))
 (while (/= r nil)
   (setq h(getdist "\n-mm-        Give  height : ")
         d(getreal "\nGive matl Density <7.85> : ")
         n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (/ (* pi r r h d) 3) 1000000.0)
         wtt (* wt1 n)) (princ "\n             wt. of cone = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-    Give next radius : ")) 
 )
(PRINC)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:WTCO1 (/ r r1 h d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Frustum of cone, r1,r2= radius, ht= frustum height")
   (setq r(getdist "\n-mm-     Give big radius : "))
 (while (/= r nil)
   (setq r1(getdist "\n-mm-   Give small radius : ")
          h(getdist "\n-mm-        Give  height : ")
          d(getreal "\nGive matl Density <7.85> : ")
          n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (* 1.0472 h d (+ (* r r) (* r r1) (* r1 r1))) 1000000.0)
         wtt (* wt1 n)) (princ "\n    wt.of frustumed cone = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-     Give big radius : ")) 
 )
(PRINC)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:wtcy (/ r h d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
   (setq r(getdist "\n-mm-         Give radius : "))
 (while (/= r nil)
   (setq h(getdist "\n-mm-   Give depth/height : ")
		 d(getreal "\nGive matl Density <7.85> : ")
         n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (* pi r r h d) 1000000.0)
         wtt (* wt1 n)) (princ "\n              wt of cyl. = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-    Give next radius : ")) 
 )
 (princ)
) 
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:wtcy1 (/ r r1 d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Hollow cylinder, r1,r2= radii & ht.")
   (setq  r(getdist "\n-mm-   Give outer radius : "))
 (while (/= r nil)
   (setq r1(getdist "\n-mm-   Give inner radius : ")
          h(getdist "\n-mm-   Give depth/height : ")
		  d(getreal "\nGive matl Density <7.85> : ")
          n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (* pi h d (- (* r r) (* r1 r1))) 1000000.0)
         wtt (* wt1 n)) (princ "\n       wt.of hollow cyl. = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-   Give outer radius : ")) 
 )
 (princ)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun c:wtd(/ aa wa se l b wb d n wc wct)
  (setq aa(getvar "area"))
  (setq oer *error*
       *error*  seterr)
  (initget 2 "A D")
  (setq se(getkword "\nDo you have (D/A) Dimensions or Area ? < D > : "))
(if (or (= se "D") (= se nul)) 
 (progn (setq l(getdist "\n Enter length <mm> : "))
        (setq b(getdist "\n Enter bredth <mm> : "))
        (if b  (setq wa(* l b)))) 
 (progn (princ "\n Enter measured Area in sq.mm < ") (princ aa)
        (setq wa (getreal " > : "))
        (cond ((= wa nul) (setq wa aa))))
)
(if (and (/= wa 0) (/= wa nil)) (progn  
  (setq wb (getdist "\n Depth / Perimeter / Thichness - <mm> : ")
         d (getreal "\n          Give matl. Density - <7.85> : ")
         n (getint "\n                      No. off - < 1 > : "))     (cond ((= d nul) (setq d 7.85)))
  (cond ((= n nul) (setq n 1)))
  (if wb (setq wc (/ (* (/ (* wa wb) 1000) d) 1000)))
  (princ "\n                               weight = ") 
  (princ wc) 
  (cond ((> n 1) (progn  (setq wct(* wc n))
 	           (princ (strcat " x " (rtos n) " = " (rtos wct))))))
  (princ " kgs.")
))  
  (princ)	   
) 
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun c:wtb (/ wa wb n wc wct)
 (setq oer *error*
       *error*  seterr)
  (princ"\n
  ismb 100x 75 - 11.5 kg/m
  ismb 125x 75 - 13.0 kg/m
  ismb 150x 80 - 14.9 kg/m
  ismb 175x 90 - 19.3 kg/m
  ismb 200x100 - 25.4 kg/m
  ismb 225x110 - 31.2 kg/m
  ismb 250x125 - 37.3 kg/m
  ismb 300x140 - 44.2 kg/m
  ismb 350x140 - 52.4 kg/m
  ismb 400x140 - 61.6 kg/m
  ismb 450x150 - 72.4 kg/m
  ismb 500x180 - 86.9 kg/m
  ismb 600x210 - 123  kg/m\n")
 (princ "\n   Select BEAM section -")
 (princ "\n	< 100,125,150,175,200,225,250,300,350,400,450 500 or 600 > ")
 (initget  "100 125 150 175 200 225 250 300 350 400 450 500 600")
 (setq wa (getkword ": "))
 (cond ((= wa "100") (setq wtm 11.5 )))
 (cond ((= wa "125") (setq wtm 13.0 )))
 (cond ((= wa "150") (setq wtm 14.9 )))
 (cond ((= wa "175") (setq wtm 19.3 )))
 (cond ((= wa "200") (setq wtm 25.4 )))
 (cond ((= wa "225") (setq wtm 31.2 )))
 (cond ((= wa "250") (setq wtm 37.3 )))
 (cond ((= wa "300") (setq wtm 44.2 )))
 (cond ((= wa "350") (setq wtm 52.4 )))
 (cond ((= wa "400") (setq wtm 61.6 )))
 (cond ((= wa "450") (setq wtm 72.4 )))
 (cond ((= wa "500") (setq wtm 86.9 )))
 (cond ((= wa "600") (setq wtm 123.0 )))
 (cond ((/= wa nul) (setq wb (getdist "\nEnter Length of section - <mm> : "))))
 (while (/= wb nil)
   (setq  wb(/ wb 1000.0) wc(* wtm wb))
   (setq n  (getint  "\n               No. off - < 1 > : "))
   (cond ((= n nul) (setq n 1)))
   (princ "\n              Member Weight is = ") 
   (princ wc) 
   (cond ((> n 1) 
          (progn
           (setq wct(* wc n))
           (princ " x ") 
           (princ n) 
           (princ " = ") 
           (princ wct)
          )
         )
   )
   (princ " kgs.")
   (setq wb (getdist "\n Next Length of section - <mm> : "))
 )
  (princ)
)

;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun c:wtpr (/ a h d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Any prism, a= base area, ht= height.")  
   (setq a(getreal "\n-mm-      Give base area : "))
 (while (/= a nil)
   (setq h(getdist "\n-mm-        Give  height : ")
         d(getreal "\nGive matl Density <7.85> : ")
         n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (* a h d)  3000000.0)
         wtt (* wt1 n)) (princ "\n       wt. of your prism = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq a(getreal "\n-mm-      Give next area : ")) 
 )
(PRINC)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun c:wtpy (/ a h d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Any pyramid, a= base area, ht= height.")  
   (setq a(getreal "\n-mm-      Give base area : "))
 (while (/= a nil)
   (setq h(getdist "\n-mm-        Give  height : ")
         d(getreal "\nGive matl Density <7.85> : ")
         n(getint  "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (/ (* a h d) 3)  1000000.0)
         wtt (* wt1 n)) (princ "\n     wt. of your pyramid = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq a(getreal "\n-mm-      Give next area : ")) 
 )
(PRINC)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun c:wtpy1 (/ a a1 h d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Frustum of any pyramid, a1,a2= areas, ht= height.")  
   (setq a(getreal "\n-mm-      Give base area : "))
 (while (/= a nil)
   (setq a1(getreal "\n-mm-       Give top area : ")
          h(getdist "\n-mm-        Give  height : ")
          d(getreal "\nGive matl Density <7.85> : ")
          n(getint  "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (* d (/ h 3) (+ a a1 (sqrt (* a a1))))  1000000.0)
         wtt (* wt1 n)) (princ "\n wt.of frustumed pyramid = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq a(getreal "\n-mm-      Give base area : ")) 
 )
(PRINC)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:WTSP (/ r d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
   (setq r(getdist "\n-mm-         Give radius : "))
 (while (/= r nil)
   (setq d(getreal "\nGive matl Density <7.85> : ")
         n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (/ (* 4 pi r r r d) 3) 1000000.0)
         wtt (* wt1 n)) (princ "\n            wt of sphere = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-    Give next radius : ")) 
 )
 (princ)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:WTSP1 (/ r d h n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Sphere segment, ht= depth of curve.") 
   (setq r(getdist "\n-mm-         Give radius : "))
 (while (/= r nil)
   (setq h(getdist "\n-mm-        Give  height : ")
         d(getreal "\nGive matl Density <7.85> : ")
         n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (* pi h h d (- r (/ h 3))) 1000000.0)
         wtt (* wt1 n)) (princ "\n   wt. of sphere segment = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-    Give next radius : ")) 
 )
 (princ)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:WTSP2 (/ r d h n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Sphere sector, ht= depth of curve.") 
   (setq r(getdist "\n-mm-         Give radius : "))
 (while (/= r nil)
   (setq h(getdist "\n-mm-        Give  height : ")
         d(getreal "\nGive matl Density <7.85> : ")
         n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (/ (* 2 pi r r h d) 3) 1000000.0)
         wtt (* wt1 n)) (princ "\n    wt. of sphere sector = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-    Give next radius : ")) 
 )
 (princ)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:WTSP3 (/ r d h c1 c2 n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Spherical zone, C1, C2= chord lengths, Ht= ht of zone.") 
   (setq r(getdist "\n-mm-         Give radius : "))
 (while (/= r nil)
   (setq h(getdist "\n-mm-        Give  height : ")
        c1(getdist "\n-mm-  first chord length : ")
        c2(getdist "\n-mm- second chord length : ")
		 d(getreal "\nGive matl Density <7.85> : ")
         n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (* 0.5236 h d (+ (* 3 c1 c1 0.25) (* 3 c2 c2 0.25) (* h h))) 1000000.0)
         wtt (* wt1 n)) (princ "\n    wt.of spherical zone = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-    Give next radius : ")) 
 )
 (princ)
)
;to cal. wt of area, isa, ismc, ismb & cylinder with no. off pieces 
; jan- 1993 - Basu
;------------------------------------------------------------------
(defun seterr (s)                     ;define an error handler
 (if (/= s "Function cancelled")
     (princ (strcat "\nError: " s))
 )
)
(defun C:WTSP4 (/ r1 r2 d n wt1 wtt)
 (setq oer *error*
       *error*  seterr)
 (princ "\n Hollow sphere, R1, R2= radius.") 
   (setq r(getdist "\n-mm-   Give outer radius : "))
 (while (/= r nil)
   (setq r1(getdist "\n-mm-   Give inner radius : ")
		  d(getreal "\nGive matl Density <7.85> : ")
          n(getint "\n          No. off < 1  > : "))
   (cond ((= d nul) (setq d 7.85)))		 
   (cond ((= n nul) (setq n 1)))		 
   (setq wt1 (/ (* (/ (* 4 pi d) 3) (- (* r r r) (* r1 r1 r1))) 1000000.0)
         wtt (* wt1 n)) (princ "\n     wt.of hollow sphere = ")
   (if (> n 1) (progn
                 (princ wt1) (princ " x ") (princ n) (princ " = ") (princ wtt)
			   ) (princ wt1)
   ) 
   (princ "  kgs.")
   (setq r(getdist "\n-mm-   Give outer radius : ")) 
 )
 (princ)
)
(PRINC)