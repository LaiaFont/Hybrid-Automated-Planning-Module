(define (domain planning-v2-meetings-combined)
  (:requirements :typing :fluents :time :numeric-fluents :negative-preconditions)
  (:types student task role meeting)

  ;; Predicates
  (:predicates 
    (has-role ?s - student ?r - role)
    (task-role ?t - task ?r - role)
    (assigned ?s - student ?t - task)
    (completed ?t - task)
    (meeting-scheduled ?m - meeting)
    (meeting-for-role ?m - meeting ?r - role) ;; Meeting is associated with a role
    (available ?s - student)
  )

  ;; Numeric fluents
  (:functions
    (available-time ?s - student)
    (remaining-time ?t - task)
    (priority ?t - task)
    (total-time)
  )

  ;; Action: Assign Task to a Student
  (:action assign-task
    :parameters (?s - student ?t - task ?r - role)
    :precondition (and
      (has-role ?s ?r)
      (task-role ?t ?r)
      (> (remaining-time ?t) 0)
      (> (available-time ?s) 0)
      (forall (?x - task)
        (or
          (= (priority ?x) (priority ?t))
          (> (priority ?x) (priority ?t))
          (completed ?x)
          (not (> (remaining-time ?x) 0))
        )
      )
      (forall (?x - task) (not (assigned ?s ?x)))
    )
    :effect (assigned ?s ?t)
  )

  ;; Process: Work on a Task
  (:process work-on-task
    :parameters (?s - student ?t - task)
    :precondition (and
      (assigned ?s ?t)
      (> (remaining-time ?t) 0)
      (> (available-time ?s) 0)
    )
    :effect (and
      (decrease (remaining-time ?t) (* #t 1.0))
      (decrease (available-time ?s) (* #t 1.0))
      (decrease (total-time) (* #t 1.0))
    )
  )

  ;; Action: Complete Task
  (:action complete-task
    :parameters (?s - student ?t - task)
    :precondition (and
      (assigned ?s ?t)
      (= (remaining-time ?t) 0)
    )
    :effect (and
      (completed ?t)
      (not (assigned ?s ?t))
      (available ?s)
    )
  )

  ;; Action: Schedule Meeting
  (:action schedule-meeting
    :parameters (?r - role ?m - meeting)
    :precondition (and
      (meeting-for-role ?m ?r)
      (not (meeting-scheduled ?m))
      (forall (?t - task)
        (or
          (not (task-role ?t ?r))
          (completed ?t)
        )
      )
    )
    :effect (meeting-scheduled ?m)
  )
)
