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
)
