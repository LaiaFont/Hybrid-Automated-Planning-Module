(define (problem project-plan)
  (:domain planning)

  (:objects
    student1 student2 - student
    coding1 coding2 - task
    design1 design2 - task
    research1 research2 - task
    developer designer researcher - role
    2 7 1 - number ; durations in days
  )

  (:init
    ; Student roles
    (has-role student1 developer)
    (has-role student2 designer)
    (has-role student2 researcher)

    ; Task roles and durations
    (task-role coding1 developer)
    (task-role coding2 developer)
    (task-role design1 designer)
    (task-role design2 designer)
    (task-role research1 researcher)
    (task-role research2 researcher)

    (remaining-time coding1 2)
    (remaining-time coding2 2)
    (remaining-time design1 1)
    (remaining-time design2 1)
    (remaining-time research1 7)
    (remaining-time research2 7)

    ; Students are initially available
    (available student1)
    (available student2)
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
