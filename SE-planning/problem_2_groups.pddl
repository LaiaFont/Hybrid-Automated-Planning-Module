(define (problem study_group_example)
    (:domain exam_planning_groups)

    (:objects
        alice bob charlie - student
        chapter1 chapter2 chapter3 - chapter
    )

    (:init
        ;; Students' preferences for chapters
        (has-preference alice chapter1)
        (has-preference bob chapter1)
        (has-preference charlie chapter2)
        (has-preference alice chapter3)
        (has-preference bob chapter3)

        ;; Initial available time for students
        (= (available-time alice) 6)
        (= (available-time bob) 4)
        (= (available-time charlie) 6)

        ;; Initial time needed for each cha∫pter
        (= (needed-time chapter1) 6)
        (= (needed-time chapter2) 5)
        (= (needed-time chapter3) 4)
    )

    (:goal
        (and
            (completed chapter1)
            (completed chapter2)
            (completed chapter3)
            (not (meeting-scheduled chapter1))
            (not (meeting-scheduled chapter2))
            (not (meeting-scheduled chapter3))
        )
    )
)
