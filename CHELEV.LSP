; CHELEV.LSP  Copyright 1990,91  Tony Tanzillo  All Rights Reserved.
;
; CHange ELEVation command replacement for AutoCAD(tm) Release 11.
;
; Revisions:
;
;  2/17/91 -  Revised to properly handle block insertion attributes.
;             Will now properly change the elevations of attributes
;             along with the parent entity.
;
;  3/4/91  -  Revised to properly handle 2D and 3D polylines, polygon
;             and polyface meshes, and 3DFACES, and reject DIMENSIONS
;             that are not parallel to the WCS XY plane.
;
;             Note:  3D POLYLINES, MESHES, and 3DFACES will now move in a
;                    direction parallel to the Z-axis of the CURRENT UCS,
;                    rather than the Z-axis of the WCS.
;
; Description:
;
; Changes the UCS and ECS elevation of selected geometry.  CHELEV may be
; useful to R11 users who want the editing functionality similar to that
; provided by the Release 10 CHANGE/Properties/Elevation command, which
; was dropped as of Release 11.
;
; History:
;
; In full 3D versions of AutoCAD, the entity ELEVATION field is no longer
; required, since all coordinates have Z components to describe elevation
; or the perpendicular distance from the XY plane of a coordinate system.
;
; Along with the entity elevation field, the CHANGE/Properties/Elevation
; command sequence was also dropped from AutoCAD, since there is no longer
; an explicit entity "elevation" field to change.  Along with the loss of
; this sequence, went a certain editing functionality that permitted users
; to move a selected group of objects at varying elevations to the same
; "elevation".  Just how such an operation should or could be handled in
; a 3D CAD environment with both planar and non-planar entities can be the
; subject of debate, but it is still nontheless possible to achieve.
;
; CHELEV is an attempt to reclaim this functionality even if only for use
; with 2D geometry, or in a 2D drawing scenario.  I provide no guarantee
; that CHELEV will provide 100% operational consistency with Release 10's
; Change/Elevation command, but I believe it can act as a surrogate for it
; in most situations where it may still be considered as being useful.
;
; CHELEV performs the equivalent of issuing an array of MOVE commands
; on each of the selected objects, applying different displacements to
; each one, to move them all to the same elevation (see below).
;
; The distance that each object is moved will vary, depending on the Z
; component of its primary coordinate (group 10) in relation to the new
; specified elevation and the origin of the object's UCS (for 2D objects)
; or the current UCS (for 3D objects).
;
; Note that selecting both 2D and 3D objects or several 2D objects which
; are not all parallel to each other, in a single operation may produce
; unexpected results, possibly causing some objects to move in different
; directions.
;
; Generally, 2D objects which define a PLANE should move in a direction
; parallel to their extrusion vector (the Z axis of their ECS).  All 3D
; objects will move in a direction parallel to the CURRENT UCS Z axis.
;
; An exception to the above is a 3DFACE, which by its nature does define
; a plane, but cannot be extruded.  Therefore, CHELEV treats 3DFACES as
; 3D objects, and moves them along the Z-axis of the current UCS.
;
; When changing the elevation of a 3D object (e.g., a 3D POLYLINE, MESH,
; POLYFACE MESH, or 3DFACE), an "elevation" is always defined IN TERMS OF
; the CURRENT UCS, not the WCS!  This means that these objects will always
; be displaced along the Z axis of the current UCS.  If you want to change
; the elevation of a 3D object in the WCS, then all you must do is switch
; to the WCS before invoking CHELEV.  Does this imply that one object can
; have many different "elevations"?  Yes.  How you choose to exploit this
; is up to you.
;
; When changing the elevation of a 2D object (such as a line, circle, arc
; 2D polyline, etc.), the elevation of the object is always defined in
; terms of the Z-axis of the object's own entity coordinate system (ECS),
; which means that the object will be displaced along an axis parallel to
; the object's extrusion direction (or the Z axis of object's ECS).
;
; DIMENSION entities always move along the WCS Z-axis REGARDLESS of what
; the current UCS is.  Changing the elevation of DIMENSIONS which are not
; parallel to the WCS XY plane will have unexpected results, and CHELEV
; will NOT modify any dimension that is not parallel to the WCS XY PLANE.
;
; The displacement applied to each object is the difference between the
; primary coordinate's Z component (in the current UCS for 3D objects or
; the object's ECS, for 2D objects), and the new elevation.

  (defun get (k l)
    (cond (  (listp k)
             (mapcar '(lambda (x) (cdr (assoc x l))) k))
          (t (cdr (assoc k l)))))

  (defun setelev (ent / zoff d ucselev)
     (setq zoff (- nl (cadddr (assoc 10 ent))))
     (cond
        (  (and (eq "POLYLINE" (get 0 ent))
                (not (zerop (logand 88 (get 70 ent)))))
           (setq ucselev
             (caddr (trans (get 10 (entget (entnext (get -1 ent)))) 0 1)))
           (setq zoff (- nl ucselev))
           (chelev1 ent))
        (  (equal "3DFACE" (get 0 ent))
           (chelev1 ent))
        (  (and (eq "DIMENSION" (get 0 ent))
                (not (equal (get 210 ent) '(0.0 0.0 1.0))))
           (princ "\nCannot edit DIMENSION not parallel to WCS XY plane."))
        (  (equal (get '(0 66) ent) '("INSERT" 1))
           (setq d ent)
           (while (setq d (seqnext d))
                  (chelev d))
           (chelev ent))
        (t (chelev ent)))
  )

  (defun seqnext (l / d)
     (cond
        (  (/= "SEQEND" (get 0 (setq d (entget (entnext (get -1 l)))))) d))
  )

  (defun chelev (e)
     (entmod
        (mapcar
          '(lambda (x)
              (cond (  (> 20 (car x) 9)
                       (list (car x) (cadr x) (caddr x)
                             (+ (cadddr x) zoff)))
                    (t x))) e)))

  (defun chelev1 (e)
     (command ".move" (get -1 e) "" '(0 0 0) (list 0 0 zoff))
  )

  (defun C:CHELEV ( / ss nl i ch_err hi bm)
     (setvar "cmdecho" (cond (*debug* 1) (t 0)))
     (command ".undo" "g")
     (setq hi (getvar "highlight"))
     (setq bm (getvar "blipmode"))
     (setq ch_err *error*
           *error* '((s) (repeat 2 (command))
                         (command ".undo" "e" "u")
                         (setq *error* ch_err)
                         (cond (  (member s '("console break"
                                              "Function cancelled")))
                               (t (princ (strcat "\nCHELEV Error: " s))))
                         (princ)))
     (cond (  (not (setq ss (ssget))))
           (t (initget 1)
              (setq nl (getdist "\nNew elevation: "))
              (setvar "highlight" 0)
              (setvar "blipmode" 0)
              (setq i -1)
              (repeat (sslength ss)
                      (setelev (entget (ssname ss (setq i (1+ i))))))
              (command ".select" ss "")))
     (command ".undo" "e")
     (setq *error* ch_err)
     (setvar "highlight" hi)
     (setvar "blipmode" bm)
     (princ)
  )

; ---------------------------eof CHELEV.LSP------------------------------
