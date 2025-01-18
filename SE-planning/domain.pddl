(define (domain exam_planning_groups)
    (:requirements :fluents :typing :negative-preconditions :equality)

    (:types
        student
        chapter
    )

    (:predicates
        (has-preference ?s - student ?c - chapter) ;; Students' preferences
        (group-working ?c - chapter)              ;; Indicates if a group is working
        (group-member ?s - student ?c - chapter)  ;; Tracks members of a group
        (completed ?c - chapter)                  ;; Chapter is completed
        (meeting-scheduled ?c - chapter)          ;; Meeting scheduled for a chapter
        (student-busy ?s - student)               ;; Tracks if a student is busy
    )

    (:functions
        (available-time ?s - student)             ;; Time each student has available
        (needed-time ?c - chapter)                ;; Time required to complete a chapter
    )

    ;; Start a group for a chapter with the first student
    (:action start-group
        :parameters (?s - student ?c - chapter)
        :precondition (and
            (has-preference ?s ?c)
            (not (group-working ?c))              ;; No group working yet
            (not (student-busy ?s))               ;; Student must not be busy
            (> (needed-time ?c) 0)
            (> (available-time ?s) 0)
        )
        :effect (and
            (group-working ?c)                   ;; Start the group
            (group-member ?s ?c)                 ;; Add the student to the group
            (student-busy ?s)                    ;; Mark the student as busy
        )
    )

    ;; Add a student to an existing group
    (:action join-group
        :parameters (?s - student ?c - chapter)
        :precondition (and
            (has-preference ?s ?c)
            (group-working ?c)                   ;; Group must already be active
            (not (student-busy ?s))              ;; Student must not be busy
            (> (needed-time ?c) 0)
            (> (available-time ?s) 0)
        )
        :effect (and
            (group-member ?s ?c)                 ;; Add the student to the group
            (student-busy ?s)                    ;; Mark the student as busy
        )
    )

    ;; Process for group work
    (:process work-on-task
        :parameters (?s - student ?c - chapter)
        :precondition (and
            (group-member ?s ?c)                 ;; Must be a group member
            (group-working ?c)                  ;; Group must be active
            (> (needed-time ?c) 0)
            (> (available-time ?s) 0)
        )
        :effect (and
            (decrease (needed-time ?c) #t)       ;; Reduce required time for the chapter
            (decrease (available-time ?s) #t)   ;; Reduce student's available time
        )
    )

    ;; Complete a chapter and disband the group
    (:action complete-chapter
        :parameters (?c - chapter)
        :precondition (and
            (group-working ?c)
            (= (needed-time ?c) 0)              ;; Chapter must be fully completed
        )
        :effect (and
            (completed ?c)                      ;; Mark chapter as completed
            (not (group-working ?c))            ;; Disband the group
            (forall (?s - student)
                (when (group-member ?s ?c)
                    (and
                        (not (group-member ?s ?c)) ;; Remove student from group
                        (not (student-busy ?s))    ;; Mark student as free
                    )))
            (meeting-scheduled ?c)              ;; Schedule a meeting for the chapter
        )
    )

    ;; Schedule and hold a meeting
    (:action hold-meeting
        :parameters (?c - chapter)
        :precondition (and
            (completed ?c)
            (meeting-scheduled ?c)
        )
        :effect (and
            (not (meeting-scheduled ?c))        ;; Meeting concluded
        )
    )
)