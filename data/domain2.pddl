(define (domain planning)
  (:requirements :strips :typing :durative-actions)
  (:types student task role number)

  ;; Declare predicates, including successor relationships for time tracking
  (:predicates 
    (has-role ?s - student ?r - role)
    (task-role ?t - task ?r - role)
    (assigned ?s - student ?t - task)
    (completed ?t - task)
    (available ?s - student)
    (remaining-time ?t - task ?days - number)
  )
  
  (:durative-action work-on-task
    :parameters (?s - student ?t - task ?r - role)
    :duration (= ?duration (remaining-time ?t))
    :condition
      (and 
        (over all (available ?s))
        (at start (has-role ?s ?r))
        (at start (task-role ?t ?r))
        (at start (not (completed ?t)))
      )
    :effect
      (and
        (at start (assigned ?s ?t))
        (at end (completed ?t))
        (at end (not (available ?s)))
      )
  )
)