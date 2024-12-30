(define (problem single_student_study)
    (:domain exam_planning_groups)

    (:objects
        alice - student
        chapter1 chapter2 chapter3 - chapter
    )

    (:init
        ;; Student's preferences for chapters
        (has-preference alice chapter1)
        (has-preference alice chapter2)
        (has-preference alice chapter3)

        ;; Initial available time for the student
        (= (available-time alice) 10)

        ;; Initial time needed for each chapter
        (= (needed-time chapter1) 3)
        (= (needed-time chapter2) 4)
        (= (needed-time chapter3) 3)
    )

    (:goal
        (and
            (completed chapter1)
            (completed chapter2)
            (completed chapter3)
            ;; Ensure meetings are concluded
            (not (meeting-scheduled chapter1))
            (not (meeting-scheduled chapter2))
            (not (meeting-scheduled chapter3))
        )
    )
)
