(define (domain planning)
  (:requirements :typing :fluents :time :numeric-fluents :negative-preconditions)
  (:types student task role meeting)

  ;; Predicates
  (:predicates 
    (has-role ?s - student ?r - role)
    (task-role ?t - task ?r - role)
    (assigned ?s - student ?t - task)
    (completed ?t - task)
    (meeting-scheduled ?m - meeting)
    (meeting-for-role ?m - meeting ?r - role)
    (available ?s - student)
  )

  ;; Numeric fluents
  (:functions
    (available-time ?s - student)
    (remaining-time ?t - task)
    (priority ?t - task)
    (total-time)
    (points ?s - student) ;; Points earned by a student
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
      (increase (points ?s) 10) ;; Award 10 points for completing a task
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
    :effect (and
      (meeting-scheduled ?m)
      (forall (?s - student)
        (when (has-role ?s ?r)
          (increase (points ?s) 5))) ;; Award 5 points for attending a meeting
    )
  )
)
