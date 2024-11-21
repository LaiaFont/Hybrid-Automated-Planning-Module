(define (domain project-organization)
  (:requirements :strips :typing)
  (:types student task role time)

  ;; Declare predicates, including successor relationships for time tracking
  (:predicates 
    (assigned ?s - student ?t - task)          ; Student is assigned to a task
    (completed ?t - task)                      ; Task is completed
    (has-role ?s - student ?r - role)          ; Student has a specific role
    (available ?s - student)                   ; Student is available for assignment
    (in-progress ?t - task)                    ; Task is in progress
    (time-remaining ?t - task ?time - time)    ; Discrete time levels for each task
    (successor ?time1 - time ?time2 - time)    ; Successor relationship between time levels
    (final-time ?time - time)                  ; Marks the final time level for a task
  )

  ;; Define actions
  (:action assign-task
    :parameters (?s - student ?t - task ?r - role)
    :precondition (and (available ?s) (has-role ?s ?r) (not (assigned ?s ?t)))
    :effect (and (assigned ?s ?t) (not (available ?s)) (in-progress ?t))
  )

  (:action work-on-task
    :parameters (?s - student ?t - task ?time1 - time ?time2 - time)
    :precondition (and (assigned ?s ?t) (in-progress ?t) (time-remaining ?t ?time1) (successor ?time1 ?time2))
    :effect (and (not (time-remaining ?t ?time1)) (time-remaining ?t ?time2))
  )

  (:action complete-task
    :parameters (?t - task ?time - time)
    :precondition (and (in-progress ?t) (time-remaining ?t ?time) (final-time ?time))
    :effect (and (not (in-progress ?t)) (completed ?t))
  )
)