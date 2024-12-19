(define (problem biology_exam_study)
    (:domain exam_planning_groups)

    ;; Define the objects
    (:objects
        Alice Bob Charlie Dana Evan - student
        chapter1 chapter2 chapter3 chapter4 chapter5 - chapter
    )

    ;; Initial state
    (:init
        ;; Student preferences for chapters
        (has-preference Alice chapter1)
        (has-preference Alice chapter2)
        (has-preference Bob chapter1)
        (has-preference Bob chapter3)
        (has-preference Charlie chapter1)
        (has-preference Dana chapter2)
        (has-preference Dana chapter3)
        (has-preference Evan chapter4)
        (has-preference Evan chapter5)

        ;; Available time for each student (in hours)
        (= (available-time Alice) 20)
        (= (available-time Bob) 25)
        (= (available-time Charlie) 15)
        (= (available-time Dana) 30)
        (= (available-time Evan) 25)

        ;; Needed time for each chapter (in hours)
        (= (needed-time chapter1) 30)
        (= (needed-time chapter2) 15)
        (= (needed-time chapter3) 10)
        (= (needed-time chapter4) 5)
        (= (needed-time chapter5) 20)
    )

    ;; Goal state
    (:goal
        (and
            ;; All chapters must be completed
            (completed chapter1)
            (completed chapter2)
            (completed chapter3)
            (completed chapter4)
            (completed chapter5)

            (not (meeting-scheduled chapter1))
            (not (meeting-scheduled chapter2))
            (not (meeting-scheduled chapter3))
            (not (meeting-scheduled chapter4))
            (not (meeting-scheduled chapter5))
        )
    )
)
