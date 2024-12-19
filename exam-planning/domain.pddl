(define (domain exam_planning)
    (:requirements :fluents :typing :conditional-effects :negative-preconditions :equality)

    (:types
        student
        chapter
    )

    (:predicates
        (has-preference ?s - student ?c - chapter)
        (assigned ?s - student ?c - chapter)
        (completed ?c - chapter)
        (meeting-scheduled ?c - chapter)
    )

    (:functions
        (available-time ?s - student)
        (needed-time ?c - chapter)
        (points ?s - student)
    )

    (:action assign-chapter
        :parameters (?s - student ?c - chapter)
        :precondition (and 
            (not (assigned ?s ?c))
            (has-preference ?s ?c)
            (>= (available-time ?s) (needed-time ?c))
            (> (needed-time ?c) 0)
        )
        :effect (and 
            (assigned ?s ?c)
        )
    )

    (:process work-on-task
        :parameters (?s - student ?c - chapter)
        :precondition (and
            (assigned ?s ?c)
            (> (needed-time ?c) 0)
            (> (available-time ?s) 0)
        )
        :effect (and
            (decrease (needed-time ?c) #t)
            (decrease (available-time ?s) #t)
        )
    )

    (:action complete-chapter
        :parameters (?s - student ?c - chapter)
        :precondition (and 
            (assigned ?s ?c)
            (= (needed-time ?c) 0)
        )
        :effect (and 
            (completed ?c)
            (not (assigned ?s ?c))
            (increase (points ?s) 10)
            (meeting-scheduled ?c)
        )
    )

    (:action hold-meeting
        :parameters (?c - chapter)
        :precondition (and
            (completed ?c)
            (meeting-scheduled ?c)
        )
        :effect (and
            (not (meeting-scheduled ?c))
        )
    )
)
