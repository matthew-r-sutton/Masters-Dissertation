extensions [ csv ]
breed [ people a-person]
breed [ jobs job ] ;; jobs are places of employment held by many people
people-own
[
  current-utility
  income ;; ranges from 1 to 100--calibrated with XXX data
  age ;; ranges from 18 to max--currently all ages are equally possible upon initialization, but this should be calibrated to real US data
  race ;; ranges from 1 to 5--numbers correlate to white, hispanic/latino, black/african american, asian, and other, respectively
  occupation-type ;; 1 (tertiary--services) or 2 (secondary--industrial)
]
jobs-own
[
  job-type ;; ranges from 1 to 3--each 'type' has a different distribution of ISCO-job-group combinations; should be calibrated to real US data
  capacity ;; the number of people that an employment opportunity sustains; initialized with US Census Bureau data on the establishment size distribution
]
patches-own
[
  price
  amenities
  job-1-dist
  job-2-dist
  job-1-utility
  job-2-utility
]
globals
[
  data

  urbanized_area_name
  initial_1-4
  initial_5-17
  initial_18-19
  initial_20-24
  initial_25-29
  initial_30-34
  initial_35-39
  initial_40-44
  initial_45-49
  initial_50-54
  initial_55-59
  initial_$1-9999      ; 1-10
  initial_$10000-14999 ; 11-15
  initial_$15000-24999 ; 16-25
  initial_$25000-34999 ; 26-35
  initial_$35000-49999 ; 36-50
  initial_$50000-64999 ; 51-65
  initial_$65000-74999 ; 66-75
  initial_white
  initial_latino
  initial_black
  initial_asian

  migration_rate
  migration_st_dev
  unemp_rate
  unemp_st_dev
  birth_rate
  birth_st_dev
  death_rate
  death_st_dev

  change_1-4
  change_5-17
  change_18-19
  change_20-24
  change_25-29
  change_30-34
  change_35-39
  change_40-44
  change_45-49
  change_50-54
  change_55-59
  change_$1-9999
  change_$10000-14999
  change_$15000-24999
  change_$25000-34999
  change_$35000-49999
  change_$50000-64999
  change_$65000-74999
  change_white
  change_latino
  change_black
  change_asian

  initial-population
  initial-amenities
  population-density
  employment-density
  half-side-length

  prop_tertiary_job
  prop_tertiary_people

  pareto_alpha

  job_1_amenity_effect
  job_1_price_effect
  job_2_amenity_effect
  job_2_price_effect

  vacant_amenity_effect
  vacant_price_effect

  hood_price_effect
  hood_amenities_effect

  view-mode
  min-poor-util
  max-poor-util
  min-rich-util
  max-rich-util
  population-change
  num-1-jobs
  num-2-jobs
  max-dist
  pct-gentrified
  working-age-list
  pct-pop-change
]

;;
;; Setup Procedures
;;

to setup
  clear-all
  set view-mode "price"
  setup-data
  setup-patches
  setup-jobs
  setup-people
  set-neighborhood-effects
  set working-age-list (list working-population)
  update-patch-color
  reset-ticks
end

to setup-data
  set data csv:from-file "/final_data.csv"
  ; shout out to Luke C for the following foreach loop
  ; https://stackoverflow.com/questions/43798668/netlogo-foreach-nested-list
  foreach data
  [
    urbanized_area  ->
    if (item 0 urbanized_area = urbanized-area-index)
    [
      set urbanized_area_name item 1 urbanized_area

      set initial_1-4 item 2 urbanized_area
      set initial_5-17 item 3 urbanized_area
      set initial_18-19 item 4 urbanized_area
      set initial_20-24 item 5 urbanized_area
      set initial_25-29 item 6 urbanized_area
      set initial_30-34 item 7 urbanized_area
      set initial_35-39 item 8 urbanized_area
      set initial_40-44 item 9 urbanized_area
      set initial_45-49 item 10 urbanized_area
      set initial_50-54 item 11 urbanized_area
      set initial_55-59 item 12 urbanized_area

      set initial_$1-9999 item 13 urbanized_area
      set initial_$10000-14999 item 14 urbanized_area
      set initial_$15000-24999 item 15 urbanized_area
      set initial_$25000-34999 item 16 urbanized_area
      set initial_$35000-49999 item 17 urbanized_area
      set initial_$50000-64999 item 18 urbanized_area
      set initial_$65000-74999 item 19 urbanized_area

      set initial_white item 20 urbanized_area
      set initial_latino item 21 urbanized_area
      set initial_black item 22 urbanized_area
      set initial_asian item 23 urbanized_area

      set migration_rate item 24 urbanized_area
      set migration_st_dev item 25 urbanized_area
      set unemp_rate item 26 urbanized_area
      set unemp_st_dev item 27 urbanized_area
      set birth_rate item 28 urbanized_area
      set birth_st_dev item 29 urbanized_area
      set death_rate item 30 urbanized_area
      set death_st_dev item 31 urbanized_area

      set change_1-4 item 32 urbanized_area
      set change_5-17 item 33 urbanized_area
      set change_18-19 item 34 urbanized_area
      set change_20-24 item 35 urbanized_area
      set change_25-29 item 36 urbanized_area
      set change_30-34 item 37 urbanized_area
      set change_35-39 item 38 urbanized_area
      set change_40-44 item 39 urbanized_area
      set change_45-49 item 40 urbanized_area
      set change_50-54 item 41 urbanized_area
      set change_55-59 item 42 urbanized_area

      set change_$1-9999 item 43 urbanized_area
      set change_$10000-14999 item 44 urbanized_area
      set change_$15000-24999 item 45 urbanized_area
      set change_$25000-34999 item 46 urbanized_area
      set change_$35000-49999 item 47 urbanized_area
      set change_$50000-64999 item 48 urbanized_area
      set change_$65000-74999 item 49 urbanized_area

      set change_white item 50 urbanized_area
      set change_latino item 51 urbanized_area
      set change_black item 52 urbanized_area
      set change_asian item 53 urbanized_area

      set initial-population round(item 54 urbanized_area)
      set initial-amenities round item 55 urbanized_area
      set population-density round (item 56 urbanized_area * item 57 urbanized_area)
      set employment-density item 58 urbanized_area
      set half-side-length round(item 59 urbanized_area / 2) + 1

      set prop_tertiary_job item 60 urbanized_area
      set prop_tertiary_people item 61 urbanized_area

      set pareto_alpha item 62 urbanized_area

      set job_1_amenity_effect item 63 urbanized_area
      set job_1_price_effect item 64 urbanized_area
      set job_2_amenity_effect item 65 urbanized_area
      set job_2_price_effect item 66 urbanized_area

      set vacant_amenity_effect item 67 urbanized_area
      set vacant_price_effect item 68 urbanized_area

      set hood_price_effect item 69 urbanized_area
      set hood_amenities_effect item 70 urbanized_area
    ]
  ]
end

to setup-patches
  resize-world (-1 * half-side-length) half-side-length (-1 * half-side-length) half-side-length
  set-patch-size 500 / (2 * half-side-length)

  ask patches
  [
    set amenities initial-amenities
    set price 1
  ]
  set max-dist round [distance patch max-pxcor max-pycor] of patch min-pxcor max-pxcor
end

to setup-jobs
  ;initialize a job on patch 0 0 to mitigate the possiblility of the world's edges
  ;constraining growth
  create-jobs 1
  ask jobs
  [
    set shape "circle"
    set size 0.5
    set job-type 1
    set-job-color
    set capacity round random-pareto pareto_alpha
    set num-1-jobs (num-1-jobs + 1)
  ]
  ask n-of 1 patches
  [
    sprout-jobs 1
    [
      set shape "circle"
      set size 0.5
      set job-type 2
      set-job-color
      set capacity round random-pareto pareto_alpha
      set num-2-jobs (num-2-jobs + 1)
    ]
  ]
  update-patch-vars
  locate-jobs round(initial-population * (1 - initial_5-17))
end

to setup-people
  create-people initial-population
  ask people
  [
    set shape "box"
    set-occupation-type
    set-race
    set-income
    set-color
    set-age
    ifelse age > 17
      [evaluate-migration income]
      [set hidden? true]
  ]
end

to-report random-pareto [#alpha]
  ;shoutout to JenB for the basis of this code
  ;(https://stackoverflow.com/questions/28317479/how-to-create-a-random-pareto-in-netlogo)
  report 1 / ( random-float 1 ^ (1 / #alpha) )
end

to set-job-type
  ifelse (random-float 1 <= prop_tertiary_job)
  [
    set job-type 1
    set num-1-jobs (num-1-jobs + 1)
  ]
  [
    set job-type 2
    set num-2-jobs (num-2-jobs + 1)
  ]
end

to set-job-color
  ifelse (job-type = 1)
    [set color violet]
    [set color blue]
end

to increase-amenities [#origin-increase]
  ask patch-here
  [
    ifelse (amenities * (1 + #origin-increase)) < 100
      [set amenities (amenities * (1 + #origin-increase))]
      [set amenities 100]
    ask patches in-radius 1
    [
      ifelse (amenities * (1 + #origin-increase / 3)) < 100
        [set amenities (amenities * (1 + #origin-increase / 3))]
        [set amenities 100]
    ]
    ask patches in-radius 2
    [
      ifelse (amenities * (1 + #origin-increase / 9)) < 100
        [set amenities (amenities * (1 + #origin-increase / 9))]
        [set amenities 100]
    ]
  ]
end

to decrease-amenities [#origin-decrease]
  ask patch-here
  [
    ifelse (amenities * (1 - #origin-decrease)) > 0
      [set amenities (amenities * (1 - #origin-decrease))]
      [set amenities 1]
    ask patches in-radius 1
    [
      ifelse (amenities * (1 - #origin-decrease / 3)) > 0
        [set amenities (amenities * (1 - #origin-decrease / 3))]
        [set amenities 1]
    ]
    ask patches in-radius 2
    [
      ifelse (amenities * (1 - #origin-decrease / 9)) > 0
        [set amenities (amenities * (1 - #origin-decrease / 9))]
        [set amenities 1]
    ]
  ]
end

to increase-price [#origin-increase]
  ask patch-here
  [
    ifelse (price * (1 + #origin-increase)) < 100
      [set price ( price * (1 + #origin-increase))]
      [set price 100]
    ask patches in-radius 1
    [
      ifelse price * (1 + #origin-increase / 3) < 100
        [set price (price * (1 + #origin-increase / 3))]
        [set price 100]
    ]
  ]
end

to decrease-price [#origin-decrease]
  ask patch-here
  [
    ifelse (price * (1 - #origin-decrease)) > 1
      [set price (price * (1 - #origin-decrease))]
      [set price 1]
    ask patches in-radius 1
    [
      ifelse (price * (1 - #origin-decrease / 3)) > 1
        [set price (price * (1 - #origin-decrease / 3))]
        [set price 1]
    ]
    ask patches in-radius 2
    [
      ifelse (price * (1 - #origin-decrease / 9)) > 1
        [set price (price * (1 - #origin-decrease / 9))]
        [set price 1]
    ]
  ]
end

to update-patch-vars
  ask patches
  [
    set-job-distances
    set-job-utilities
  ]
end

to set-job-distances
  if (num-1-jobs >= 1) [set job-1-dist min [distance myself] of jobs with [job-type = 1]]
  if (num-2-jobs >= 1) [set job-2-dist min [distance myself] of jobs with [job-type = 2]]
  if job-1-dist = 0  [set job-1-dist 0.1]
  if job-2-dist = 0  [set job-2-dist 0.1]
end

to set-job-utilities
  let max-job-1-utility (( ((0.1 - (max-dist)) ^ 2) / (0.1 * (max-dist ^ 2)) ) + ( 100 ^ (2) / 10000) + (( (100) / (10000 * (100 - 101) ^ 2) )))
  let max-job-2-utility ( (((0.1 - (max-dist)) ^ 2) / (0.1 * (max-dist ^ 2)) ) + (1 / 1 ^ (2)) )
  set job-1-utility (( ((job-1-dist - (max-dist)) ^ 2) / (job-1-dist * (max-dist ^ 2)) ) + ( price ^ (2) / 10000) + (( (amenities) / (10000 * (amenities - 101) ^ 2) ))) / max-job-1-utility
  set job-2-utility ( (((job-2-dist - (max-dist)) ^ 2) / (job-2-dist * (max-dist ^ 2)) ) + (1 / price ^ 2) ) / max-job-2-utility
end

to locate-jobs [#population]
  ; while the capacity of jobs is below the observed employment rate, create new jobs
  let unemployment_rate random-normal unemp_rate unemp_st_dev
  while [sum [capacity] of jobs < round (#population - (#population * (unemployment_rate)))]
  [
    let possible-capacity round random-pareto 1.098
    while [possible-capacity > employment-density or possible-capacity = 0]
      [set possible-capacity round random-pareto 1.098]

    let possible-job-type 0
    ifelse (random-float 1 <= prop_tertiary_job)
      [set possible-job-type 1]
      [set possible-job-type 2]

    ; while job capacity of the number of eligible patches (those with a capacity < 0 and no people and no jobs-here of the other type) is > 0
    if  (any? patches with [ (sum [capacity] of jobs-here + possible-capacity < employment-density) and (count people-here with [age > 17] = 0) and (not any? jobs-here with [job-type != possible-job-type])])
    [
      let candidate-patches patches with [(sum [capacity] of jobs-here + possible-capacity) < employment-density and (count people-here with [age > 17] = 0) and (not any? jobs-here with [job-type != possible-job-type])]

      ifelse possible-job-type = 1
      [
        let best-candidate max-one-of candidate-patches [job-1-utility]

        ask best-candidate
        [
          sprout-jobs 1
          [
            set shape "circle"
            set size 0.5
            set job-type possible-job-type
            set-job-color
            set capacity possible-capacity
            set num-1-jobs (num-1-jobs + 1)
          ]
        ]
        update-patch-vars
      ]
      [
        let best-candidate max-one-of candidate-patches [job-2-utility]

        ask best-candidate
        [
          sprout-jobs 1
          [
            set shape "circle"
            set size 0.5
            set job-type possible-job-type
            set-job-color
            set capacity possible-capacity
            set num-2-jobs (num-2-jobs + 1)
          ]
        ]
        update-patch-vars
      ]
    ]
  ]
end

to set-age
  let proxy random-float 1
  if proxy <= initial_1-4 [set age 1 + random 4]
  if proxy > initial_1-4 and proxy <= initial_5-17 [set age 5 + random 13]
  if proxy > initial_5-17 and proxy <= initial_18-19 [set age 18 + random 2]
  if proxy > initial_18-19 and proxy <= initial_20-24 [set age 20 + random 5]
  if proxy > initial_20-24 and proxy <= initial_25-29 [set age 25 + random 5]
  if proxy > initial_25-29 and proxy <= initial_30-34 [set age 30 + random 5]
  if proxy > initial_30-34 and proxy <= initial_35-39 [set age 35 + random 5]
  if proxy > initial_35-39 and proxy <= initial_40-44 [set age 40 + random 5]
  if proxy > initial_40-44 and proxy <= initial_45-49 [set age 45 + random 5]
  if proxy > initial_45-49 and proxy <= initial_50-54 [set age 50 + random 5]
  if proxy > initial_50-54 and proxy <= initial_55-59 [set age 55 + random 5]
  if proxy > initial_55-59 [set age 60 + random 5]
end

to set-race
  let proxy random-float 1
  if proxy <= initial_white [set race 1]
  if proxy > initial_white and proxy <= initial_latino [set race 2]
  if proxy > initial_latino and proxy <= initial_black [set race 3]
  if proxy > initial_black and proxy <= initial_asian [set race 4]
  if proxy > initial_asian [set race 5]
end

to set-income
  let proxy random-float 1
  if proxy <= initial_$1-9999 [set income 1 + random 10]
  if proxy > initial_$1-9999 and proxy <= initial_$10000-14999 [set income 11 + random 5]
  if proxy > initial_$10000-14999 and proxy <= initial_$15000-24999 [set income 16 + random 10]
  if proxy > initial_$15000-24999 and proxy <= initial_$25000-34999 [set income 26 + random 10]
  if proxy > initial_$25000-34999 and proxy <= initial_$35000-49999 [set income 36 + random 15]
  if proxy > initial_$35000-49999 and proxy <= initial_$50000-64999 [set income 51 + random 15]
  if proxy > initial_$50000-64999 and proxy <= initial_$65000-74999 [set income 66 + random 10]
  if proxy > initial_$65000-74999 [set income 76 + random 25]
end

to set-occupation-type
  ifelse (random-float 1 <= prop_tertiary_people)
    [set occupation-type 1]
    [set occupation-type 2]
end

to evaluate-migration [#income]
  let candidate-patches patches with [count(people-here) < population-density and count(jobs-here) = 0 and price <= #income]
  if not any? candidate-patches  [die]
  if (occupation-type = 1)
  [
    let best-candidate max-one-of candidate-patches [occupation-1-utility #income]
    if current-utility < [occupation-1-utility #income] of best-candidate
    [
      move-to best-candidate
      set current-utility [occupation-1-utility #income] of best-candidate
    ]
  ]
  if occupation-type = 2
  [
    let best-candidate max-one-of candidate-patches [occupation-2-utility #income]
    if current-utility < [occupation-2-utility #income] of best-candidate
    [
      move-to best-candidate
      set current-utility [occupation-2-utility #income] of best-candidate
    ]
  ]
end

to-report occupation-1-utility [#income]
  ; all classes exhibit a 60:40, amenity:employment preference structure
  ; all classes prefer to be closer to jobs, but poor weight this factor more than mid,
  ; who weight it more than rich
  ; poor attempt to minimize estate price, while mid and rich try to maximize it
  ; rich place more weight on estate price than job distance, while poor do the opposite
  ; all classes try to maximize amenities
  let employment-factors ( ( ((1 / #income) * ((job-1-dist - (max-dist)) ^ 2)) / (job-1-dist * (max-dist ^ 2))) ) * (1 - amenities-priority)
  let amenity-factors ( ( (amenities * #income) / (10000 * (amenities - 101) ^ 2)  * 0.5) + ( ( 1 / ((#income - price) ^ 2 + 1)) * 0.5)) * (amenities-priority)
  report (employment-factors + amenity-factors)
end

to-report occupation-2-utility [#income]
  let employment-factors ( ( ((1 / #income) * ((job-2-dist - (max-dist)) ^ 2)) / (job-2-dist * (max-dist ^ 2))) ) * (1 - amenities-priority)
  let amenity-factors ( ( (amenities * #income) / (10000 * (amenities - 101) ^ 2)  * 0.5) + ( ( 1 / ((#income - price) ^ 2 + 1)) * 0.5)) * (amenities-priority)
  report (employment-factors + amenity-factors)
end

to set-color
  if (income <= 25)  [set color  18]
  if (income > 25 and income <= 75 )  [set color 15]
  if (income > 75)  [set color 12]
end

to set-neighborhood-effects
  ask patches
  [
    if mean-neighborhood-income > 0
    [
      set-neighborhood-price hood_price_effect mean-neighborhood-income
      set-neighborhood-amenities hood_amenities_effect mean-neighborhood-income

      ask patches in-radius 1
      [
        set-neighborhood-price (hood_price_effect / 3) mean-neighborhood-income
        set-neighborhood-amenities (hood_amenities_effect / 3) mean-neighborhood-income
      ]
    ]
  ]
end

to-report mean-neighborhood-income
  let income-of-self sum [income] of people-here with [age > 17]
  let income-of-neighbors sum [income] of (people-on neighbors4) with [age > 17]
  let number-of-people-on-self count people-here with [age > 17]
  let number-of-people-on-neighbors count (people-on neighbors4) with [age > 17]

  ifelse (number-of-people-on-self + number-of-people-on-neighbors) > 0
    [report round ((income-of-self + income-of-neighbors) / (number-of-people-on-self + number-of-people-on-neighbors))]
    [report 0]
end

to set-neighborhood-price [#price-change #mean-neighborhood-income]
  let price_income_difference (#mean-neighborhood-income - price)
  let difference_%_of_price (abs(price_income_difference) / price)

  if price_income_difference < 0
  [
    ifelse price - difference_%_of_price * #price-change * 100 > 1
      [set price price - difference_%_of_price * #price-change * 100]
      [set price 1]
  ]
  if price_income_difference > 0
  [
    ifelse price + difference_%_of_price * #price-change * 100 < 100
      [set price price + difference_%_of_price * #price-change * 100]
      [set price 100]
  ]
end

to set-neighborhood-amenities [#amenities-change #mean-neighborhood-income]
  let amenities_income_difference (#mean-neighborhood-income - amenities)
  let difference_%_of_amenities (abs(amenities_income_difference) / amenities)

  if amenities_income_difference < 0
  [
    ifelse amenities - difference_%_of_amenities * #amenities-change * 100 > 1
      [set amenities amenities - difference_%_of_amenities * #amenities-change * 100]
      [set amenities 1]
  ]
  if amenities_income_difference > 0
  [
    ifelse amenities + difference_%_of_amenities * #amenities-change * 100 < 100
      [set amenities amenities + difference_%_of_amenities * #amenities-change * 100]
      [set amenities 100]
  ]
end

to set-vacant-effects
  ask patches with [count jobs-here = 0 and count people-here = 0]
  [
    adjust-amenities-vacant
    decrease-price-vacant
  ]
end

to adjust-amenities-vacant
  ifelse amenities > initial-amenities
  [
    ifelse (amenities * (1 - vacant_amenity_effect)) >= initial-amenities
      [set amenities (amenities * (1 - vacant_amenity_effect))]
      [set amenities initial-amenities]
  ]
  [
    ifelse (amenities * (1 + vacant_amenity_effect)) <= initial-amenities
      [set amenities (amenities * (1 + vacant_amenity_effect))]
      [set amenities initial-amenities]
  ]
end

to decrease-price-vacant
  ifelse (price * (1 - vacant_price_effect)) > 1
    [set price (price * (1 - vacant_price_effect))]
    [set price 1]
end

to-report working-population
  report count people with [age > 17]
end

to-report underage-population
  report count people with [age < 18 and age > 0]
end

to-report newborn-population
  report count people with [age < 1]
end

;;; Runtime Procedures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  ask people with [age = 18]
    [set hidden? false]
  locate-jobs working-population
  update-patch-vars
  ask people with [age > 17]
    [evaluate-migration income]
  migrate-people
  kill-people
  set-job-neighborhood-effects
  set-neighborhood-effects
  set-vacant-effects

  update-patch-color

  ask people
    [set age ( age + 1 )]
  birth-people
  ifelse last working-age-list > 0
    [set pct-pop-change ((working-population - last working-age-list) / last working-age-list) * 100]
    [set pct-pop-change 0]
  ifelse working-population > 0
    [set pct-gentrified (total-gentrified / working-population) * 100]
    [set pct-gentrified 0]
  set working-age-list lput working-population working-age-list
  tick
;  if ticks = 33
;    [stop]
end

to set-job-neighborhood-effects
  ask jobs with [job-type = 1]
  [
    increase-amenities job_1_amenity_effect
    decrease-price job_1_price_effect
  ]
  ask jobs with [job-type = 2]
  [
    decrease-amenities job_2_amenity_effect
    increase-price job_2_price_effect
  ]
  update-patch-vars
end

to migrate-people
  set population-change round (count(people) * (random-normal migration_rate migration_st_dev))
  if population-change > 0
  [
    create-people population-change
    [
      set shape "box"
      set-migrant-race
      set-migrant-income
      set-migrant-age
      set-occupation-type
      evaluate-migration income
      set-color
    ]
  ]
  if population-change < 0
  [
    ask n-of abs population-change people  [die]
  ]
end

to set-migrant-income
  let proxy random-float 1
  while [income = 0 or income >= 101]
  [
    if proxy <= change_$1-9999 [set income 1 + random 10]
    if proxy > change_$1-9999 and proxy <= change_$10000-14999 [set income 11 + random 5]
    if proxy > change_$10000-14999 and proxy <= change_$15000-24999 [set income 16 + random 10]
    if proxy > change_$15000-24999 and proxy <= change_$25000-34999 [set income 26 + random 10]
    if proxy > change_$25000-34999 and proxy <= change_$35000-49999 [set income 36 + random 15]
    if proxy > change_$35000-49999 and proxy <= change_$50000-64999 [set income 51 + random 15]
    if proxy > change_$50000-64999 and proxy <= change_$65000-74999 [set income 66 + random 10]
    if proxy > change_$65000-74999 [set income 76 + random 25]
  ]
end

to set-migrant-race
  let proxy random-float 1
  if proxy <= change_white [set race 1]
  if proxy > change_white and proxy <= change_latino [set race 2]
  if proxy > change_latino and proxy <= change_black [set race 3]
  if proxy > change_black and proxy <= change_asian [set race 4]
  if proxy > change_asian [set race 5]
end

to set-migrant-age
  let proxy random-float 1
  if proxy <= change_18-19 [set age 18 + random 2]
  if proxy > change_18-19 and proxy <= change_20-24 [set age 20 + random 5]
  if proxy > change_20-24 and proxy <= change_25-29 [set age 25 + random 5]
  if proxy > change_25-29 and proxy <= change_30-34 [set age 30 + random 5]
  if proxy > change_30-34 and proxy <= change_35-39 [set age 35 + random 5]
  if proxy > change_35-39 and proxy <= change_40-44 [set age 40 + random 5]
  if proxy > change_40-44 and proxy <= change_45-49 [set age 45 + random 5]
  if proxy > change_45-49 and proxy <= change_50-54 [set age 50 + random 5]
  if proxy > change_50-54 and proxy <= change_55-59 [set age 55 + random 5]
  if proxy > change_55-59 [set age 60 + random 5]
end

to kill-people
  let death-rate (random-normal death_rate death_st_dev)
  ask n-of (round (death-rate * count people)) people  [die]
  ask people with [age > 64]  [die]
end

to birth-people
  let birth-rate random-normal birth_rate birth_st_dev
  create-people round (birth-rate * working-population)
  [
    set shape "box"
    set age 0
    set-birth-income
    set-birth-race
    set-occupation-type
    set-color
    set hidden? true
  ]
end

to set-birth-race
  let proxy random-float 1
  let white-proportion count people with [age > 17 and race = 1] / working-population
  let latino-proportion count people with [age > 17 and (race = 1 or race = 2)] / working-population
  let black-proportion count people with [age > 17 and (race = 1 or race = 2 or race = 3)] / working-population
  let asian-proportion count people with [age > 17 and (race != 5)] / working-population

  if proxy <= white-proportion [set race 1]
  if proxy > white-proportion and proxy <= latino-proportion [set race 2]
  if proxy > latino-proportion and proxy <= black-proportion [set race 3]
  if proxy > black-proportion and proxy <= asian-proportion [set race 4]
  if proxy > asian-proportion [set race 5]
end


to set-birth-income
  let proxy random-float 1
  let $1-9999-proportion count people with [income <= 10 and age > 17]
  let $10000-14999-proportion count people with [income <= 15 and age > 17]
  let $15000-24999-proportion count people with [income <= 25 and age > 17]
  let $25000-34999-proportion count people with [income <= 35 and age > 17]
  let $35000-49999-proportion count people with [income <= 40 and age > 17]
  let $50000-64999-proportion count people with [income <= 65 and age > 17]
  let $65000-74999-proportion count people with [income <= 75 and age > 17]

  while [income = 0 or income = 101]
  [
    if proxy <= $1-9999-proportion [set income 1 + random 10]
    if proxy > $1-9999-proportion and proxy <= $10000-14999-proportion [set income 11 + random 5]
    if proxy > $10000-14999-proportion and proxy <= $15000-24999-proportion [set income 16 + random 10]
    if proxy > $15000-24999-proportion and proxy <= $25000-34999-proportion [set income 26 + random 10]
    if proxy > $25000-34999-proportion and proxy <= $35000-49999-proportion [set income 36 + random 15]
    if proxy > $35000-49999-proportion and proxy <= $50000-64999-proportion [set income 51 + random 15]
    if proxy > $50000-64999-proportion and proxy <= $65000-74999-proportion [set income 66 + random 10]
    if proxy > $65000-74999-proportion [set income 76 + random 25]
  ]
end

to-report total-gentrified
  report count people with [age > 17 and [price] of patch-here > income]
end

;;
;; Visualization Procedures
;;

to update-patch-color
  ;; the particular constants we use to scale the colors in the display
  ;; are mainly chosen for visual appeal
  ask patches
  [
    if view-mode = "amenities"
      [set pcolor scale-color cyan amenities 0 200]
    if view-mode = "price"
      [set pcolor scale-color yellow price 0 200]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
205
60
728
584
-1
-1
34.33333333333334
1
10
1
1
1
0
0
0
1
-7
7
-7
7
1
1
1
ticks
100.0

BUTTON
5
10
60
44
NIL
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
60
10
140
44
NIL
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
0

BUTTON
141
10
196
44
go-once
go
NIL
1
T
OBSERVER
NIL
1
NIL
NIL
0

BUTTON
5
45
100
79
view price
set view-mode \"price\"\nupdate-patch-color
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
100
45
197
80
view amenities
set view-mode \"amenities\"\nupdate-patch-color
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
900
265
1060
385
race
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ";set-plot-pen-mode 1\nifelse ticks > 33\n[set-plot-x-range (ticks - 33)  (ticks + 1)]\n[set-plot-x-range 0 (ticks + 1)]\nset-plot-y-range 0 item 0 modes [race] of people  \n;set-histogram-num-bars 5"
PENS
"white" 1.0 0 -5825686 true "" "plot count people with [race = 1]"
"hispanic" 1.0 0 -13840069 true "" "plot count people with [race = 2]"
"black" 1.0 0 -2674135 true "" "plot count people with [race = 3]"
"asian" 1.0 0 -14835848 true "" "plot count people with [race = 4]"
"other" 1.0 0 -955883 true "" "plot count people with [race = 5]"

PLOT
737
140
897
260
age
NIL
NIL
0.0
10.0
0.0
10.0
false
false
"set-plot-pen-mode 1\nset-plot-x-range 18 65\nlet common-age item 0 (modes [age] of people with [age > 17])\nset-plot-y-range 0 (count people with [age = common-age and age > 17])\nset-histogram-num-bars 50\n  " "let common-age item 0 (modes [age] of people with [age > 17])\nset-plot-y-range 0 (count people with [age = common-age and age > 17])"
PENS
"default" 1.0 1 -16777216 true "" "histogram [age] of people with [age > 17]"

PLOT
737
262
897
382
job capacity
Capacity
jobs
0.0
10.0
0.0
10.0
true
false
"set-plot-pen-mode 1\nset-plot-x-range 1 max [capacity] of jobs + 1\nset-plot-y-range 0 count(jobs) + 1" "set-plot-x-range 1 max [capacity] of jobs + 1\nset-plot-y-range 0 (item 0 modes [capacity] of jobs) + 1\nset-histogram-num-bars max [capacity] of jobs + 1"
PENS
"default" 1.0 1 -16777216 true "" "histogram [capacity] of jobs"

PLOT
900
140
1060
260
income
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"set-plot-pen-mode 1\nlet common-income item 0 (modes [income] of people with [age > 17])\nset-plot-y-range 1 (count people with [income = common-income and age > 17])" "set-plot-pen-mode 1\nset-plot-x-range 1 101\nlet common-income item 0 (modes [income] of people with [age > 17])\nset-plot-y-range 1 (count people with [income = common-income and age > 17])\nset-histogram-num-bars 20"
PENS
"default" 1.0 0 -16777216 true "" "histogram [income] of people with [age > 17]"

PLOT
900
12
1060
132
Migration Rate
Time (yrs.)
Rate (%)
0.0
10.0
0.0
10.0
true
false
"set-plot-x-range 0 1\nset-plot-y-range -5 5  \n" "ifelse ticks > 33\n[set-plot-x-range (ticks - 33)  (ticks + 1)]\n[set-plot-x-range 0 (ticks + 1)]\n  \n"
PENS
"default" 1.0 0 -16777216 true "" "plot (population-change / count(people)) * 100"

MONITOR
120
240
172
285
% rich
(count people with [income > 75 and age > 17] / working-population) * 100
1
1
11

MONITOR
120
150
172
195
% poor
(count people with [income <= 25 and age > 17] / working-population) * 100
1
1
11

MONITOR
120
195
172
240
% mid
(count people with [income <= 75 and income > 25 and age > 17] / working-population) * 100
1
1
11

MONITOR
0
265
87
310
working pop.
working-population
17
1
11

MONITOR
95
315
180
360
# type 1 jobs
num-1-jobs
17
1
11

MONITOR
95
360
180
405
# type 2 jobs
num-2-jobs
17
1
11

PLOT
737
12
897
132
Working Age Pop.
time (yrs.)
people
0.0
10.0
0.0
10.0
true
false
"" "set-plot-x-range 0 (ticks + 1)"
PENS
"default" 1.0 0 -16777216 true "" "plot count people with [age > 17]"

MONITOR
95
405
180
450
job capacity
reduce + [capacity] of jobs
17
1
11

SLIDER
5
115
197
148
amenities-priority
amenities-priority
0
1
0.5
.05
1
NIL
HORIZONTAL

MONITOR
1
312
88
357
underage pop.
underage-population
17
1
11

MONITOR
1
358
88
403
newborn pop.
newborn-population
17
1
11

MONITOR
1
403
88
448
total pop.
count people
17
1
11

MONITOR
5
150
91
195
pop. density
population-density
0
1
11

SLIDER
5
80
197
113
urbanized-area-index
urbanized-area-index
1
224
145.0
1
1
NIL
HORIZONTAL

MONITOR
205
10
730
55
modeled urbanized area
urbanized_area_name
17
1
11

MONITOR
836
393
918
438
NIL
pct-gentrified
4
1
11

MONITOR
736
395
831
440
NIL
pct-pop-change
4
1
11

MONITOR
6
200
90
245
NIL
initial-amenities
17
1
11

@#$#@#$#@
## WHAT IS IT?

URGGENTUS is an abstract, land-use ABM designed to forecast urban growth and gentrification of working-age (18-64) individuals resulting from historical birth, death, and net migration trends, for the 224 US urbanized areas that had a mean population and total working-age population between 100,000 and 1,000,000, during 2013-2017. Agents’ Tiebout preferences determine where they locate. Notably, people can decide to relocate from one year to the next, but jobs cannot. This is because we make the unrealistic assumption that once employment capacity is established it exists forever. Clearly, this is not realistic, as some employers go out of business or jobs are replaced by automation. This is only one of the many, possibly erroneous, assumptions that were made when designing URGGENTUS. 

## HOW IT WORKS

Please refer to my dissertation provided in the GitHub repository that appears as part of the suggested citation for this model. The dissertation will appear there following return of marks. 

## HOW TO USE IT

Please refer to my dissertation provided in the GitHub repository that appears as part of the suggested citation for this model. The dissertation will appear there following return of marks. 

## THINGS TO NOTICE

During the first few steps, large urban ares look especially fractally!

## THINGS TO TRY

Try changing the amenities-priority parameter to see how this effects results. 

## EXTENDING THE MODEL

The estimator for gentrification has much variability. It would be useful to determine a way to mitigate this.

## NETLOGO FEATURES

Breeds are used to define jobs and people

## RELATED MODELS

Felsen & Wilensky's Economic Disparity model inspired this one, so we assume any inspiration for their model is also related to this one!

## CREDITS AND REFERENCES

This model was loosely based on a model originally written by Michael Felsen and Uri Wilensky:

Felsen, M. and Wilensky, U. (2007).  NetLogo Urban Suite - Economic Disparity model.  http://ccl.northwestern.edu/netlogo/models/UrbanSuite-EconomicDisparity.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, please credit me:

Sutton, M. (2019). URGENTUS Netlogo Model. https://github.com/nottuswehttam/dissertation.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bee
true
0
Polygon -1184463 true false 151 152 137 77 105 67 89 67 66 74 48 85 36 100 24 116 14 134 0 151 15 167 22 182 40 206 58 220 82 226 105 226 134 222
Polygon -16777216 true false 151 150 149 128 149 114 155 98 178 80 197 80 217 81 233 95 242 117 246 141 247 151 245 177 234 195 218 207 206 211 184 211 161 204 151 189 148 171
Polygon -7500403 true true 246 151 241 119 240 96 250 81 261 78 275 87 282 103 277 115 287 121 299 150 286 180 277 189 283 197 281 210 270 222 256 222 243 212 242 192
Polygon -16777216 true false 115 70 129 74 128 223 114 224
Polygon -16777216 true false 89 67 74 71 74 224 89 225 89 67
Polygon -16777216 true false 43 91 31 106 31 195 45 211
Line -1 false 200 144 213 70
Line -1 false 213 70 213 45
Line -1 false 214 45 203 26
Line -1 false 204 26 185 22
Line -1 false 185 22 170 25
Line -1 false 169 26 159 37
Line -1 false 159 37 156 55
Line -1 false 157 55 199 143
Line -1 false 200 141 162 227
Line -1 false 162 227 163 241
Line -1 false 163 241 171 249
Line -1 false 171 249 190 254
Line -1 false 192 253 203 248
Line -1 false 205 249 218 235
Line -1 false 218 235 200 144

bird1
false
0
Polygon -7500403 true true 2 6 2 39 270 298 297 298 299 271 187 160 279 75 276 22 100 67 31 0

bird2
false
0
Polygon -7500403 true true 2 4 33 4 298 270 298 298 272 298 155 184 117 289 61 295 61 105 0 43

boat1
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

boat2
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 157 54 175 79 174 96 185 102 178 112 194 124 196 131 190 139 192 146 211 151 216 154 157 154
Polygon -7500403 true true 150 74 146 91 139 99 143 114 141 123 137 126 131 129 132 139 142 136 126 142 119 147 148 147

boat3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
true
0
Polygon -7500403 true true 45 255 255 255 255 45 45 45

butterfly1
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

circle
false
0
Circle -7500403 true true 35 35 230

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

person
false
0
Circle -7500403 true true 155 20 63
Rectangle -7500403 true true 158 79 217 164
Polygon -7500403 true true 158 81 110 129 131 143 158 109 165 110
Polygon -7500403 true true 216 83 267 123 248 143 215 107
Polygon -7500403 true true 167 163 145 234 183 234 183 163
Polygon -7500403 true true 195 163 195 233 227 233 206 159

sheep
false
15
Rectangle -1 true true 90 75 270 225
Circle -1 true true 15 75 150
Rectangle -16777216 true false 81 225 134 286
Rectangle -16777216 true false 180 225 238 285
Circle -16777216 true false 1 88 92

spacecraft
true
0
Polygon -7500403 true true 150 0 180 135 255 255 225 240 150 180 75 240 45 255 120 135

thin-arrow
true
0
Polygon -7500403 true true 150 0 0 150 120 150 120 293 180 293 180 150 300 150

truck-down
false
0
Polygon -7500403 true true 225 30 225 270 120 270 105 210 60 180 45 30 105 60 105 30
Polygon -8630108 true false 195 75 195 120 240 120 240 75
Polygon -8630108 true false 195 225 195 180 240 180 240 225

truck-left
false
0
Polygon -7500403 true true 120 135 225 135 225 210 75 210 75 165 105 165
Polygon -8630108 true false 90 210 105 225 120 210
Polygon -8630108 true false 180 210 195 225 210 210

truck-right
false
0
Polygon -7500403 true true 180 135 75 135 75 210 225 210 225 165 195 165
Polygon -8630108 true false 210 210 195 225 180 210
Polygon -8630108 true false 120 210 105 225 90 210

turtle
true
0
Polygon -7500403 true true 138 75 162 75 165 105 225 105 225 142 195 135 195 187 225 195 225 225 195 217 195 202 105 202 105 217 75 225 75 195 105 187 105 135 75 142 75 105 135 105

wolf
false
0
Rectangle -7500403 true true 15 105 105 165
Rectangle -7500403 true true 45 90 105 105
Polygon -7500403 true true 60 90 83 44 104 90
Polygon -16777216 true false 67 90 82 59 97 89
Rectangle -1 true false 48 93 59 105
Rectangle -16777216 true false 51 96 55 101
Rectangle -16777216 true false 0 121 15 135
Rectangle -16777216 true false 15 136 60 151
Polygon -1 true false 15 136 23 149 31 136
Polygon -1 true false 30 151 37 136 43 151
Rectangle -7500403 true true 105 120 263 195
Rectangle -7500403 true true 108 195 259 201
Rectangle -7500403 true true 114 201 252 210
Rectangle -7500403 true true 120 210 243 214
Rectangle -7500403 true true 115 114 255 120
Rectangle -7500403 true true 128 108 248 114
Rectangle -7500403 true true 150 105 225 108
Rectangle -7500403 true true 132 214 155 270
Rectangle -7500403 true true 110 260 132 270
Rectangle -7500403 true true 210 214 232 270
Rectangle -7500403 true true 189 260 210 270
Line -7500403 true 263 127 281 155
Line -7500403 true 281 155 281 192

wolf-left
false
3
Polygon -6459832 true true 117 97 91 74 66 74 60 85 36 85 38 92 44 97 62 97 81 117 84 134 92 147 109 152 136 144 174 144 174 103 143 103 134 97
Polygon -6459832 true true 87 80 79 55 76 79
Polygon -6459832 true true 81 75 70 58 73 82
Polygon -6459832 true true 99 131 76 152 76 163 96 182 104 182 109 173 102 167 99 173 87 159 104 140
Polygon -6459832 true true 107 138 107 186 98 190 99 196 112 196 115 190
Polygon -6459832 true true 116 140 114 189 105 137
Rectangle -6459832 true true 109 150 114 192
Rectangle -6459832 true true 111 143 116 191
Polygon -6459832 true true 168 106 184 98 205 98 218 115 218 137 186 164 196 176 195 194 178 195 178 183 188 183 169 164 173 144
Polygon -6459832 true true 207 140 200 163 206 175 207 192 193 189 192 177 198 176 185 150
Polygon -6459832 true true 214 134 203 168 192 148
Polygon -6459832 true true 204 151 203 176 193 148
Polygon -6459832 true true 207 103 221 98 236 101 243 115 243 128 256 142 239 143 233 133 225 115 214 114

wolf-right
false
3
Polygon -6459832 true true 170 127 200 93 231 93 237 103 262 103 261 113 253 119 231 119 215 143 213 160 208 173 189 187 169 190 154 190 126 180 106 171 72 171 73 126 122 126 144 123 159 123
Polygon -6459832 true true 201 99 214 69 215 99
Polygon -6459832 true true 207 98 223 71 220 101
Polygon -6459832 true true 184 172 189 234 203 238 203 246 187 247 180 239 171 180
Polygon -6459832 true true 197 174 204 220 218 224 219 234 201 232 195 225 179 179
Polygon -6459832 true true 78 167 95 187 95 208 79 220 92 234 98 235 100 249 81 246 76 241 61 212 65 195 52 170 45 150 44 128 55 121 69 121 81 135
Polygon -6459832 true true 48 143 58 141
Polygon -6459832 true true 46 136 68 137
Polygon -6459832 true true 45 129 35 142 37 159 53 192 47 210 62 238 80 237
Line -16777216 false 74 237 59 213
Line -16777216 false 59 213 59 212
Line -16777216 false 58 211 67 192
Polygon -6459832 true true 38 138 66 149
Polygon -6459832 true true 46 128 33 120 21 118 11 123 3 138 5 160 13 178 9 192 0 199 20 196 25 179 24 161 25 148 45 140
Polygon -6459832 true true 67 122 96 126 63 144
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="400" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="33"/>
    <metric>pct-pop-change</metric>
    <metric>pct-gentrified</metric>
    <enumeratedValueSet variable="urbanized-area-index">
      <value value="145"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="amenities-priority">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
