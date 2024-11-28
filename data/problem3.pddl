(define (problem project-plan)
  (:domain planning)

  (:objects
    student1 student2 student3 - student
    coding1 coding2 - task
    design1 design2 - task
    research1 research2 - task
    developer designer researcher - role
  )

  (:init
    ;; Student roles
    (has-role student1 developer)
    (has-role student3 developer)
    (has-role student2 designer)
    (has-role student2 researcher)
    (has-role student3 researcher)

    (= (available-time student1) 5)
    (= (available-time student2) 8)
    (= (available-time student3) 10)

    (= (points student1) 0)
    (= (points student2) 0)
    (= (points student3) 0)

    ;; Task roles
    (task-role coding1 developer)
    (task-role coding2 developer)
    (task-role design1 designer)
    (task-role design2 designer)
    (task-role research1 researcher)
    (task-role research2 researcher)

    ;; Task durations
    (= (remaining-time coding1) 2)
    (= (remaining-time coding2) 2)
    (= (remaining-time design1) 1)
    (= (remaining-time design2) 1)
    (= (remaining-time research1) 7)
    (= (remaining-time research2) 7)

    ;; Task priorities
    (= (priority coding1) 1) ;; Highest priority
    (= (priority coding2) 2)
    (= (priority design1) 3)
    (= (priority design2) 4)
    (= (priority research1) 1)
    (= (priority research2) 3)

    ;; Initialize total time (arbitrarily high value for minimization)
    (= (total-time) 60)
  )

  (:goal
    (and
      (completed coding1)
      (completed coding2)
      (completed design1)
      (completed design2)
      (completed research1)
      (completed research2)
    )
  )

 
  (:metric minimize (- (+ (total-time) (- (points student1)) (- (points student2)) (- (points student3)))))
)
