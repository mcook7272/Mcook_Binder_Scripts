USE [JHM_OMOP_ID_Projection];

CREATE TABLE #Codesets (
   codeset_id INT NOT NULL
   ,concept_id BIGINT NOT NULL
   );

INSERT INTO #Codesets (
   codeset_id
   ,concept_id
   )
SELECT 1 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (43013884, 40239216, 40166035, 1580747, 19122137)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (43013884, 40239216, 40166035, 1580747, 19122137)
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 2 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (44816332, 45774435, 1583722, 40170911, 44506754, 793143)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (44816332, 45774435, 1583722, 40170911, 44506754, 793143)
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 3 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (43526465, 44785829, 45774751, 793293)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (43526465, 44785829, 45774751, 793293)
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 4 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (1594973, 1597756, 1560171, 19097821, 1559684, 1502809, 1502855)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (1594973, 1597756, 1560171, 19097821, 1559684, 1502809, 1502855
            )
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 5 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (
            1529331, 1530014, 730548, 19033498, 19001409, 19059796, 19001441, 1510202, 1502826, 1525215, 
            1516766, 1547504, 1515249
            )
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (
            1529331, 1530014, 730548, 19033498, 19001409, 19059796, 19001441, 1510202, 1502826, 1525215, 
            1516766, 1547504, 1515249
            )
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 6 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (
            1596977, 1550023, 1567198, 1502905, 1513876, 1531601, 1586346, 1544838, 1516976, 1590165, 1513849, 
            1562586, 1588986, 1513843, 1586369, 35605670, 35602717, 21600713
            )
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (
            1596977, 1550023, 1567198, 1502905, 1513876, 1531601, 1586346, 1544838, 1516976, 1590165, 1513849, 
            1562586, 1588986, 1513843, 1586369, 35605670, 35602717, 21600713
            )
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 7 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (1503297)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (1503297)
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 8 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (
            319844, 321318, 312337, 4278217, 40484167, 318443, 314659, 40479625, 372924, 376713, 381591, 315286
            , 44782819, 316995, 134057, 442774, 439847, 434056, 4146311, 4329847, 4296029, 317309, 321822, 
            313928, 321052, 44782775, 441039, 4067424, 443239, 4318842, 432923, 439040, 4141106, 4194610, 
            4189293
            )
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (
            319844, 321318, 312337, 4278217, 40484167, 318443, 40479625, 372924, 376713, 381591, 315286, 
            44782819, 316995, 442774, 439847, 434056, 4146311, 4329847, 4296029, 317309, 321822, 313928, 
            44782775, 441039, 4067424, 443239, 4318842, 432923, 439040, 4141106, 4194610, 4189293
            )
         AND c.invalid_reason IS NULL
      ) I
   LEFT JOIN (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (
            4124841, 40484541, 312902, 4288310, 316494, 4313767, 372721, 40480453, 46272492, 4324690, 441246, 
            380113, 192763, 4275428, 260841, 318137, 320749, 440417, 380943, 320741, 4132546, 318169, 443752, 
            432346
            )
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (
            4124841, 40484541, 312902, 4288310, 316494, 4313767, 372721, 40480453, 46272492, 4324690, 441246, 
            380113, 192763, 4275428, 260841, 318137, 320749, 440417, 380943, 320741, 4132546, 318169, 443752, 
            432346
            )
         AND c.invalid_reason IS NULL
      ) E ON I.concept_id = E.concept_id
   WHERE E.concept_id IS NULL
   ) C

UNION ALL

SELECT 9 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (4150819, 4331725)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (4150819, 4331725)
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 10 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (195771)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (195771)
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 11 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (201254, 435216, 200687, 377821, 318712)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (201254, 435216, 200687, 377821, 318712)
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 12 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (201826, 443734, 443767, 192279, 443735, 376065, 443729, 443732)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (201826, 443734, 443767, 192279, 443735, 376065, 443729, 443732
            )
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 13 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (4030518)
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (4030518)
         AND c.invalid_reason IS NULL
      ) I
   ) C

UNION ALL

SELECT 14 AS codeset_id
   ,c.concept_id
FROM (
   SELECT DISTINCT I.concept_id
   FROM (
      SELECT concept_id
      FROM dbo.CONCEPT
      WHERE concept_id IN (
            44816332, 43013884, 43526465, 1594973, 44785829, 45774435, 45774751, 793293, 1583722, 1597756, 
            1560171, 19097821, 1559684, 40239216, 40170911, 44506754, 40166035, 793143, 1580747, 1502809, 
            1502855, 19122137
            )
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         AND ca.ancestor_concept_id IN (
            44816332, 43013884, 43526465, 1594973, 44785829, 45774435, 45774751, 793293, 1583722, 1597756, 
            1560171, 19097821, 1559684, 40239216, 40170911, 44506754, 40166035, 793143, 1580747, 1502809, 
            1502855, 19122137
            )
         AND c.invalid_reason IS NULL
      ) I
   ) C;

WITH primary_events (
   event_id
   ,person_id
   ,start_date
   ,end_date
   ,op_start_date
   ,op_end_date
   ,visit_occurrence_id
   )
AS (
   -- Begin Primary Events
   SELECT P.ordinal AS event_id
      ,P.person_id
      ,P.start_date
      ,P.end_date
      ,op_start_date
      ,op_end_date
      ,cast(P.visit_occurrence_id AS BIGINT) AS visit_occurrence_id
   FROM (
      SELECT E.person_id
         ,E.start_date
         ,E.end_date
         ,row_number() OVER (
            PARTITION BY E.person_id ORDER BY E.sort_date ASC
            ) ordinal
         ,OP.observation_period_start_date AS op_start_date
         ,OP.observation_period_end_date AS op_end_date
         ,cast(E.visit_occurrence_id AS BIGINT) AS visit_occurrence_id
      FROM (
         -- Begin Drug Exposure Criteria
         SELECT C.person_id
            ,C.drug_exposure_id AS event_id
            ,C.drug_exposure_start_date AS start_date
            ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, DRUG_EXPOSURE_START_DATE), 
               DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS end_date
            ,C.visit_occurrence_id
            ,C.drug_exposure_start_date AS sort_date
         FROM (
            SELECT de.*
               ,row_number() OVER (
                  PARTITION BY de.person_id ORDER BY de.drug_exposure_start_date
                     ,de.drug_exposure_id
                  ) AS ordinal
            FROM dbo.DRUG_EXPOSURE de
            INNER JOIN #Codesets codesets ON (
                  (
                     de.drug_concept_id = codesets.concept_id
                     AND codesets.codeset_id = 4
                     )
                  )
            ) C
         WHERE C.ordinal = 1
            -- End Drug Exposure Criteria
         ) E
      INNER JOIN dbo.observation_period OP ON E.person_id = OP.person_id
         AND E.start_date >= OP.observation_period_start_date
         AND E.start_date <= op.observation_period_end_date
      WHERE DATEADD(day, 365, OP.OBSERVATION_PERIOD_START_DATE) <= E.START_DATE
         AND DATEADD(day, 0, E.START_DATE) <= OP.OBSERVATION_PERIOD_END_DATE
      ) P
   WHERE P.ordinal = 1
      -- End Primary Events
   )

select * into #primary_events from primary_events; 

SELECT event_id
   ,person_id
   ,start_date
   ,end_date
   ,op_start_date
   ,op_end_date
   ,visit_occurrence_id
INTO #qualified_events
FROM (
   SELECT pe.event_id
      ,pe.person_id
      ,pe.start_date
      ,pe.end_date
      ,pe.op_start_date
      ,pe.op_end_date
      ,row_number() OVER (
         PARTITION BY pe.person_id ORDER BY pe.start_date ASC
         ) AS ordinal
      ,cast(pe.visit_occurrence_id AS BIGINT) AS visit_occurrence_id
   FROM #primary_events pe
   INNER JOIN (
      -- Begin Criteria Group
      SELECT 0 AS index_id
         ,person_id
         ,event_id
      FROM (
         SELECT E.person_id
            ,E.event_id
         FROM #primary_events E
         INNER JOIN (
            -- Begin Correlated Criteria
            SELECT 0 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #primary_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #primary_events P
               INNER JOIN (
                  -- Begin Drug Exposure Criteria
                  SELECT C.person_id
                     ,C.drug_exposure_id AS event_id
                     ,C.drug_exposure_start_date AS start_date
                     ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, 
                           DRUG_EXPOSURE_START_DATE), DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS 
                     end_date
                     ,C.visit_occurrence_id
                     ,C.drug_exposure_start_date AS sort_date
                  FROM (
                     SELECT de.*
                     FROM dbo.DRUG_EXPOSURE de
                     INNER JOIN #Codesets codesets ON (
                           (
                              de.drug_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 1
                              )
                           )
                     ) C
                     -- End Drug Exposure Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Correlated Criteria
            SELECT 1 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #primary_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #primary_events P
               INNER JOIN (
                  -- Begin Drug Exposure Criteria
                  SELECT C.person_id
                     ,C.drug_exposure_id AS event_id
                     ,C.drug_exposure_start_date AS start_date
                     ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, 
                           DRUG_EXPOSURE_START_DATE), DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS 
                     end_date
                     ,C.visit_occurrence_id
                     ,C.drug_exposure_start_date AS sort_date
                  FROM (
                     SELECT de.*
                     FROM dbo.DRUG_EXPOSURE de
                     INNER JOIN #Codesets codesets ON (
                           (
                              de.drug_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 2
                              )
                           )
                     ) C
                     -- End Drug Exposure Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Correlated Criteria
            SELECT 2 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #primary_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #primary_events P
               INNER JOIN (
                  -- Begin Drug Exposure Criteria
                  SELECT C.person_id
                     ,C.drug_exposure_id AS event_id
                     ,C.drug_exposure_start_date AS start_date
                     ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, 
                           DRUG_EXPOSURE_START_DATE), DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS 
                     end_date
                     ,C.visit_occurrence_id
                     ,C.drug_exposure_start_date AS sort_date
                  FROM (
                     SELECT de.*
                     FROM dbo.DRUG_EXPOSURE de
                     INNER JOIN #Codesets codesets ON (
                           (
                              de.drug_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 3
                              )
                           )
                     ) C
                     -- End Drug Exposure Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Correlated Criteria
            SELECT 3 AS index_id
               ,cc.person_id
               ,cc.event_id
            FROM (
               SELECT p.person_id
                  ,p.event_id
               FROM #primary_events P
               INNER JOIN (
                  -- Begin Condition Occurrence Criteria
                  SELECT C.person_id
                     ,C.condition_occurrence_id AS event_id
                     ,C.condition_start_date AS start_date
                     ,COALESCE(C.condition_end_date, DATEADD(day, 1, C.condition_start_date)) AS end_date
                     ,C.visit_occurrence_id
                     ,C.condition_start_date AS sort_date
                  FROM (
                     SELECT co.*
                     FROM dbo.CONDITION_OCCURRENCE co
                     INNER JOIN #Codesets codesets ON (
                           (
                              co.condition_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 12
                              )
                           )
                     ) C
                     -- End Condition Occurrence Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc
            GROUP BY cc.person_id
               ,cc.event_id
            HAVING COUNT(cc.event_id) >= 1
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Correlated Criteria
            SELECT 4 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #primary_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #primary_events P
               INNER JOIN (
                  -- Begin Condition Occurrence Criteria
                  SELECT C.person_id
                     ,C.condition_occurrence_id AS event_id
                     ,C.condition_start_date AS start_date
                     ,COALESCE(C.condition_end_date, DATEADD(day, 1, C.condition_start_date)) AS end_date
                     ,C.visit_occurrence_id
                     ,C.condition_start_date AS sort_date
                  FROM (
                     SELECT co.*
                     FROM dbo.CONDITION_OCCURRENCE co
                     INNER JOIN #Codesets codesets ON (
                           (
                              co.condition_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 11
                              )
                           )
                     ) C
                     -- End Condition Occurrence Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Correlated Criteria
            SELECT 5 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #primary_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #primary_events P
               INNER JOIN (
                  -- Begin Condition Occurrence Criteria
                  SELECT C.person_id
                     ,C.condition_occurrence_id AS event_id
                     ,C.condition_start_date AS start_date
                     ,COALESCE(C.condition_end_date, DATEADD(day, 1, C.condition_start_date)) AS end_date
                     ,C.visit_occurrence_id
                     ,C.condition_start_date AS sort_date
                  FROM (
                     SELECT co.*
                     FROM dbo.CONDITION_OCCURRENCE co
                     INNER JOIN #Codesets codesets ON (
                           (
                              co.condition_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 10
                              )
                           )
                     ) C
                     -- End Condition Occurrence Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Correlated Criteria
            SELECT 6 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #primary_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #primary_events P
               INNER JOIN (
                  -- Begin Drug Exposure Criteria
                  SELECT C.person_id
                     ,C.drug_exposure_id AS event_id
                     ,C.drug_exposure_start_date AS start_date
                     ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, 
                           DRUG_EXPOSURE_START_DATE), DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS 
                     end_date
                     ,C.visit_occurrence_id
                     ,C.drug_exposure_start_date AS sort_date
                  FROM (
                     SELECT de.*
                     FROM dbo.DRUG_EXPOSURE de
                     INNER JOIN #Codesets codesets ON (
                           (
                              de.drug_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 5
                              )
                           )
                     ) C
                     -- End Drug Exposure Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Demographic Criteria
            SELECT 7 AS index_id
               ,e.person_id
               ,e.event_id
            FROM #primary_events E
            INNER JOIN dbo.PERSON P ON P.PERSON_ID = E.PERSON_ID
            WHERE YEAR(E.start_date) - P.year_of_birth >= 18
            GROUP BY e.person_id
               ,e.event_id
               -- End Demographic Criteria
            ) CQ ON E.person_id = CQ.person_id
            AND E.event_id = CQ.event_id
         GROUP BY E.person_id
            ,E.event_id
         HAVING COUNT(index_id) = 8
         ) G
         -- End Criteria Group
      ) AC ON AC.person_id = pe.person_id
      AND AC.event_id = pe.event_id
   ) QE
WHERE QE.ordinal = 1;

--- Inclusion Rule Inserts
SELECT 0 AS inclusion_rule_id
   ,person_id
   ,event_id
INTO #Inclusion_0
FROM (
   SELECT pe.person_id
      ,pe.event_id
   FROM #qualified_events pe
   INNER JOIN (
      -- Begin Criteria Group
      SELECT 0 AS index_id
         ,person_id
         ,event_id
      FROM (
         SELECT E.person_id
            ,E.event_id
         FROM #qualified_events E
         INNER JOIN (
            -- Begin Demographic Criteria
            SELECT 0 AS index_id
               ,e.person_id
               ,e.event_id
            FROM #qualified_events E
            INNER JOIN dbo.PERSON P ON P.PERSON_ID = E.PERSON_ID
            WHERE YEAR(E.start_date) - P.year_of_birth >= 45
            GROUP BY e.person_id
               ,e.event_id
            -- End Demographic Criteria
            
            UNION ALL
            
            -- Begin Demographic Criteria
            SELECT 1 AS index_id
               ,e.person_id
               ,e.event_id
            FROM #qualified_events E
            INNER JOIN dbo.PERSON P ON P.PERSON_ID = E.PERSON_ID
            WHERE YEAR(E.start_date) - P.year_of_birth < 65
            GROUP BY e.person_id
               ,e.event_id
               -- End Demographic Criteria
            ) CQ ON E.person_id = CQ.person_id
            AND E.event_id = CQ.event_id
         GROUP BY E.person_id
            ,E.event_id
         HAVING COUNT(index_id) = 2
         ) G
         -- End Criteria Group
      ) AC ON AC.person_id = pe.person_id
      AND AC.event_id = pe.event_id
   ) Results;

SELECT 1 AS inclusion_rule_id
   ,person_id
   ,event_id
INTO #Inclusion_1
FROM (
   SELECT pe.person_id
      ,pe.event_id
   FROM #qualified_events pe
   INNER JOIN (
      -- Begin Criteria Group
      SELECT 0 AS index_id
         ,person_id
         ,event_id
      FROM (
         SELECT E.person_id
            ,E.event_id
         FROM #qualified_events E
         INNER JOIN (
            -- Begin Demographic Criteria
            SELECT 0 AS index_id
               ,e.person_id
               ,e.event_id
            FROM #qualified_events E
            INNER JOIN dbo.PERSON P ON P.PERSON_ID = E.PERSON_ID
            WHERE P.gender_concept_id IN (8532)
            GROUP BY e.person_id
               ,e.event_id
               -- End Demographic Criteria
            ) CQ ON E.person_id = CQ.person_id
            AND E.event_id = CQ.event_id
         GROUP BY E.person_id
            ,E.event_id
         HAVING COUNT(index_id) = 1
         ) G
         -- End Criteria Group
      ) AC ON AC.person_id = pe.person_id
      AND AC.event_id = pe.event_id
   ) Results;

SELECT 2 AS inclusion_rule_id
   ,person_id
   ,event_id
INTO #Inclusion_2
FROM (
   SELECT pe.person_id
      ,pe.event_id
   FROM #qualified_events pe
   INNER JOIN (
      -- Begin Criteria Group
      SELECT 0 AS index_id
         ,person_id
         ,event_id
      FROM (
         SELECT E.person_id
            ,E.event_id
         FROM #qualified_events E
         INNER JOIN (
            -- Begin Demographic Criteria
            SELECT 0 AS index_id
               ,e.person_id
               ,e.event_id
            FROM #qualified_events E
            INNER JOIN dbo.PERSON P ON P.PERSON_ID = E.PERSON_ID
            WHERE P.race_concept_id IN (
                  8516, 38003598, 38003599, 38003600, 38003601, 38003602, 38003603, 38003604, 38003605, 
                  38003606, 38003607, 38003608, 38003609
                  )
               AND P.race_concept_id IN (
                  8516, 38003598, 38003599, 38003600, 38003601, 38003602, 38003603, 38003604, 38003605, 
                  38003606, 38003607, 38003608, 38003609
                  )
            GROUP BY e.person_id
               ,e.event_id
               -- End Demographic Criteria
            ) CQ ON E.person_id = CQ.person_id
            AND E.event_id = CQ.event_id
         GROUP BY E.person_id
            ,E.event_id
         HAVING COUNT(index_id) = 1
         ) G
         -- End Criteria Group
      ) AC ON AC.person_id = pe.person_id
      AND AC.event_id = pe.event_id
   ) Results;

SELECT 3 AS inclusion_rule_id
   ,person_id
   ,event_id
INTO #Inclusion_3
FROM (
   SELECT pe.person_id
      ,pe.event_id
   FROM #qualified_events pe
   INNER JOIN (
      -- Begin Criteria Group
      SELECT 0 AS index_id
         ,person_id
         ,event_id
      FROM (
         SELECT E.person_id
            ,E.event_id
         FROM #qualified_events E
         INNER JOIN (
            -- Begin Correlated Criteria
            SELECT 0 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #qualified_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #qualified_events P
               INNER JOIN (
                  -- Begin Condition Occurrence Criteria
                  SELECT C.person_id
                     ,C.condition_occurrence_id AS event_id
                     ,C.condition_start_date AS start_date
                     ,COALESCE(C.condition_end_date, DATEADD(day, 1, C.condition_start_date)) AS end_date
                     ,C.visit_occurrence_id
                     ,C.condition_start_date AS sort_date
                  FROM (
                     SELECT co.*
                     FROM dbo.CONDITION_OCCURRENCE co
                     INNER JOIN #Codesets codesets ON (
                           (
                              co.condition_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 8
                              )
                           )
                     ) C
                     -- End Condition Occurrence Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Correlated Criteria
            SELECT 1 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #qualified_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #qualified_events P
               INNER JOIN (
                  -- Begin Procedure Occurrence Criteria
                  SELECT C.person_id
                     ,C.procedure_occurrence_id AS event_id
                     ,C.procedure_date AS start_date
                     ,DATEADD(d, 1, C.procedure_date) AS END_DATE
                     ,C.visit_occurrence_id
                     ,C.procedure_date AS sort_date
                  FROM (
                     SELECT po.*
                     FROM dbo.PROCEDURE_OCCURRENCE po
                     INNER JOIN #Codesets codesets ON (
                           (
                              po.procedure_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 9
                              )
                           )
                     ) C
                     -- End Procedure Occurrence Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
               -- End Correlated Criteria
            ) CQ ON E.person_id = CQ.person_id
            AND E.event_id = CQ.event_id
         GROUP BY E.person_id
            ,E.event_id
         HAVING COUNT(index_id) = 2
         ) G
         -- End Criteria Group
      ) AC ON AC.person_id = pe.person_id
      AND AC.event_id = pe.event_id
   ) Results;

SELECT 4 AS inclusion_rule_id
   ,person_id
   ,event_id
INTO #Inclusion_4
FROM (
   SELECT pe.person_id
      ,pe.event_id
   FROM #qualified_events pe
   INNER JOIN (
      -- Begin Criteria Group
      SELECT 0 AS index_id
         ,person_id
         ,event_id
      FROM (
         SELECT E.person_id
            ,E.event_id
         FROM #qualified_events E
         INNER JOIN (
            -- Begin Correlated Criteria
            SELECT 0 AS index_id
               ,cc.person_id
               ,cc.event_id
            FROM (
               SELECT p.person_id
                  ,p.event_id
               FROM #qualified_events P
               INNER JOIN (
                  -- Begin Condition Occurrence Criteria
                  SELECT C.person_id
                     ,C.condition_occurrence_id AS event_id
                     ,C.condition_start_date AS start_date
                     ,COALESCE(C.condition_end_date, DATEADD(day, 1, C.condition_start_date)) AS end_date
                     ,C.visit_occurrence_id
                     ,C.condition_start_date AS sort_date
                  FROM (
                     SELECT co.*
                     FROM dbo.CONDITION_OCCURRENCE co
                     INNER JOIN #Codesets codesets ON (
                           (
                              co.condition_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 13
                              )
                           )
                     ) C
                     -- End Condition Occurrence Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc
            GROUP BY cc.person_id
               ,cc.event_id
            HAVING COUNT(cc.event_id) >= 1
               -- End Correlated Criteria
            ) CQ ON E.person_id = CQ.person_id
            AND E.event_id = CQ.event_id
         GROUP BY E.person_id
            ,E.event_id
         HAVING COUNT(index_id) = 1
         ) G
         -- End Criteria Group
      ) AC ON AC.person_id = pe.person_id
      AND AC.event_id = pe.event_id
   ) Results;

SELECT 5 AS inclusion_rule_id
   ,person_id
   ,event_id
INTO #Inclusion_5
FROM (
   SELECT pe.person_id
      ,pe.event_id
   FROM #qualified_events pe
   INNER JOIN (
      -- Begin Criteria Group
      SELECT 0 AS index_id
         ,person_id
         ,event_id
      FROM (
         SELECT E.person_id
            ,E.event_id
         FROM #qualified_events E
         INNER JOIN (
            -- Begin Correlated Criteria
            SELECT 0 AS index_id
               ,cc.person_id
               ,cc.event_id
            FROM (
               SELECT p.person_id
                  ,p.event_id
               FROM #qualified_events P
               INNER JOIN (
                  -- Begin Drug Era Criteria
                  SELECT C.person_id
                     ,C.drug_era_id AS event_id
                     ,C.drug_era_start_date AS start_date
                     ,C.drug_era_end_date AS end_date
                     ,CAST(NULL AS BIGINT) AS visit_occurrence_id
                     ,C.drug_era_start_date AS sort_date
                  FROM (
                     SELECT de.*
                     FROM dbo.DRUG_ERA de
                     WHERE de.drug_concept_id IN (
                           SELECT concept_id
                           FROM #Codesets
                           WHERE codeset_id = 7
                           )
                     ) C
                  WHERE DATEDIFF(d, C.drug_era_start_date, C.drug_era_end_date) >= 90
                     -- End Drug Era Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, - 90, P.START_DATE)
               ) cc
            GROUP BY cc.person_id
               ,cc.event_id
            HAVING COUNT(cc.event_id) >= 1
            -- End Correlated Criteria
            
            UNION ALL
            
            -- Begin Correlated Criteria
            SELECT 1 AS index_id
               ,cc.person_id
               ,cc.event_id
            FROM (
               SELECT p.person_id
                  ,p.event_id
               FROM #qualified_events P
               INNER JOIN (
                  -- Begin Drug Exposure Criteria
                  SELECT C.person_id
                     ,C.drug_exposure_id AS event_id
                     ,C.drug_exposure_start_date AS start_date
                     ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, 
                           DRUG_EXPOSURE_START_DATE), DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS 
                     end_date
                     ,C.visit_occurrence_id
                     ,C.drug_exposure_start_date AS sort_date
                  FROM (
                     SELECT de.*
                     FROM dbo.DRUG_EXPOSURE de
                     INNER JOIN #Codesets codesets ON (
                           (
                              de.drug_concept_id = codesets.concept_id
                              AND codesets.codeset_id = 7
                              )
                           )
                     ) C
                     -- End Drug Exposure Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc
            GROUP BY cc.person_id
               ,cc.event_id
            HAVING COUNT(cc.event_id) >= 3
               -- End Correlated Criteria
            ) CQ ON E.person_id = CQ.person_id
            AND E.event_id = CQ.event_id
         GROUP BY E.person_id
            ,E.event_id
         HAVING COUNT(index_id) > 0
         ) G
         -- End Criteria Group
      ) AC ON AC.person_id = pe.person_id
      AND AC.event_id = pe.event_id
   ) Results;

SELECT 6 AS inclusion_rule_id
   ,person_id
   ,event_id
INTO #Inclusion_6
FROM (
   SELECT pe.person_id
      ,pe.event_id
   FROM #qualified_events pe
   INNER JOIN (
      -- Begin Criteria Group
      SELECT 0 AS index_id
         ,person_id
         ,event_id
      FROM (
         SELECT E.person_id
            ,E.event_id
         FROM #qualified_events E
         INNER JOIN (
            -- Begin Correlated Criteria
            SELECT 0 AS index_id
               ,p.person_id
               ,p.event_id
            FROM #qualified_events p
            LEFT JOIN (
               SELECT p.person_id
                  ,p.event_id
               FROM #qualified_events P
               INNER JOIN (
                  -- Begin Drug Era Criteria
                  SELECT C.person_id
                     ,C.drug_era_id AS event_id
                     ,C.drug_era_start_date AS start_date
                     ,C.drug_era_end_date AS end_date
                     ,CAST(NULL AS BIGINT) AS visit_occurrence_id
                     ,C.drug_era_start_date AS sort_date
                  FROM (
                     SELECT de.*
                     FROM dbo.DRUG_ERA de
                     WHERE de.drug_concept_id IN (
                           SELECT concept_id
                           FROM #Codesets
                           WHERE codeset_id = 7
                           )
                     ) C
                     -- End Drug Era Criteria
                  ) A ON A.person_id = P.person_id
                  AND A.START_DATE <= DATEADD(day, 0, P.START_DATE)
               ) cc ON p.person_id = cc.person_id
               AND p.event_id = cc.event_id
            GROUP BY p.person_id
               ,p.event_id
            HAVING COUNT(cc.event_id) = 0
               -- End Correlated Criteria
            ) CQ ON E.person_id = CQ.person_id
            AND E.event_id = CQ.event_id
         GROUP BY E.person_id
            ,E.event_id
         HAVING COUNT(index_id) = 1
         ) G
         -- End Criteria Group
      ) AC ON AC.person_id = pe.person_id
      AND AC.event_id = pe.event_id
   ) Results;

SELECT inclusion_rule_id
   ,person_id
   ,event_id
INTO #inclusion_events
FROM (
   SELECT inclusion_rule_id
      ,person_id
      ,event_id
   FROM #Inclusion_0
   
   UNION ALL
   
   SELECT inclusion_rule_id
      ,person_id
      ,event_id
   FROM #Inclusion_1
   
   UNION ALL
   
   SELECT inclusion_rule_id
      ,person_id
      ,event_id
   FROM #Inclusion_2
   
   UNION ALL
   
   SELECT inclusion_rule_id
      ,person_id
      ,event_id
   FROM #Inclusion_3
   
   UNION ALL
   
   SELECT inclusion_rule_id
      ,person_id
      ,event_id
   FROM #Inclusion_4
   
   UNION ALL
   
   SELECT inclusion_rule_id
      ,person_id
      ,event_id
   FROM #Inclusion_5
   
   UNION ALL
   
   SELECT inclusion_rule_id
      ,person_id
      ,event_id
   FROM #Inclusion_6
   ) I;

TRUNCATE TABLE #Inclusion_0;

DROP TABLE #Inclusion_0;

TRUNCATE TABLE #Inclusion_1;

DROP TABLE #Inclusion_1;

TRUNCATE TABLE #Inclusion_2;

DROP TABLE #Inclusion_2;

TRUNCATE TABLE #Inclusion_3;

DROP TABLE #Inclusion_3;

TRUNCATE TABLE #Inclusion_4;

DROP TABLE #Inclusion_4;

TRUNCATE TABLE #Inclusion_5;

DROP TABLE #Inclusion_5;

TRUNCATE TABLE #Inclusion_6;

DROP TABLE #Inclusion_6;

WITH cteIncludedEvents (
   event_id
   ,person_id
   ,start_date
   ,end_date
   ,op_start_date
   ,op_end_date
   ,ordinal
   )
AS (
   SELECT event_id
      ,person_id
      ,start_date
      ,end_date
      ,op_start_date
      ,op_end_date
	  --,POWER(cast(2 AS BIGINT), 7) - 1 "Test"
      ,row_number() OVER (
         PARTITION BY person_id ORDER BY start_date ASC
         ) AS ordinal
   FROM (
      SELECT Q.event_id
         ,Q.person_id
         ,Q.start_date
         ,Q.end_date
         ,Q.op_start_date
         ,Q.op_end_date
         ,SUM(coalesce(POWER(cast(2 AS BIGINT), I.inclusion_rule_id), 0)) AS inclusion_rule_mask
      --select inclusion_rule_id, count(*)
	  FROM #qualified_events Q
      LEFT JOIN #inclusion_events I ON I.person_id = Q.person_id
         AND I.event_id = Q.event_id
		 --group by inclusion_rule_id
      GROUP BY Q.event_id
         ,Q.person_id
         ,Q.start_date
         ,Q.end_date
         ,Q.op_start_date
         ,Q.op_end_date
		--ORDER BY inclusion_rule_mask desc
      ) MG -- matching groups
   -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask
   WHERE (MG.inclusion_rule_mask = POWER(cast(2 AS BIGINT), 7) - 1)
   )
SELECT event_id
   ,person_id
   ,start_date
   ,end_date
   ,op_start_date
   ,op_end_date
INTO #included_events
FROM cteIncludedEvents Results
WHERE Results.ordinal = 1;

-- custom era strategy
WITH ctePersons (person_id)
AS (
   SELECT DISTINCT person_id
   FROM #included_events
   )
SELECT person_id
   ,drug_exposure_start_date
   ,drug_exposure_end_date
INTO #drugTarget
FROM (
   SELECT de.PERSON_ID
      ,DRUG_EXPOSURE_START_DATE
      ,COALESCE(DRUG_EXPOSURE_END_DATE, DATEADD(day, DAYS_SUPPLY, DRUG_EXPOSURE_START_DATE), DATEADD(day
            , 1, DRUG_EXPOSURE_START_DATE)) AS DRUG_EXPOSURE_END_DATE
   FROM dbo.DRUG_EXPOSURE de
   INNER JOIN ctePersons p ON de.person_id = p.person_id
   INNER JOIN #Codesets cs ON cs.codeset_id = 4
      AND de.drug_concept_id = cs.concept_id
   
   UNION ALL
   
   SELECT de.PERSON_ID
      ,DRUG_EXPOSURE_START_DATE
      ,COALESCE(DRUG_EXPOSURE_END_DATE, DATEADD(day, DAYS_SUPPLY, DRUG_EXPOSURE_START_DATE), DATEADD(day
            , 1, DRUG_EXPOSURE_START_DATE)) AS DRUG_EXPOSURE_END_DATE
   FROM dbo.DRUG_EXPOSURE de
   INNER JOIN ctePersons p ON de.person_id = p.person_id
   INNER JOIN #Codesets cs ON cs.codeset_id = 4
      AND de.drug_source_concept_id = cs.concept_id
   ) E;

SELECT et.event_id
   ,et.person_id
   ,ERAS.era_end_date AS end_date
INTO #strategy_ends
FROM #included_events et
INNER JOIN (
   SELECT ENDS.person_id
      ,min(drug_exposure_start_date) AS era_start_date
      ,DATEADD(day, 0, ENDS.era_end_date) AS era_end_date
   FROM (
      SELECT de.person_id
         ,de.drug_exposure_start_date
         ,MIN(e.END_DATE) AS era_end_date
      FROM #drugTarget DE
      INNER JOIN (
         --cteEndDates
         SELECT PERSON_ID
            ,DATEADD(day, - 1 * 30, EVENT_DATE) AS END_DATE -- unpad the end date by 30
         FROM (
            SELECT PERSON_ID
               ,EVENT_DATE
               ,EVENT_TYPE
               ,MAX(START_ORDINAL) OVER (
                  PARTITION BY PERSON_ID ORDER BY event_date
                     ,event_type ROWS UNBOUNDED PRECEDING
                  ) AS start_ordinal
               ,ROW_NUMBER() OVER (
                  PARTITION BY PERSON_ID ORDER BY EVENT_DATE
                     ,EVENT_TYPE
                  ) AS OVERALL_ORD 
               -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
            FROM (
               -- select the start dates, assigning a row number to each
               SELECT PERSON_ID
                  ,DRUG_EXPOSURE_START_DATE AS EVENT_DATE
                  ,0 AS EVENT_TYPE
                  ,ROW_NUMBER() OVER (
                     PARTITION BY PERSON_ID ORDER BY DRUG_EXPOSURE_START_DATE
                     ) AS START_ORDINAL
               FROM #drugTarget D
               
               UNION ALL
               
               -- add the end dates with NULL as the row number, padding the end dates by 30 to allow a grace period for overlapping ranges.
               SELECT PERSON_ID
                  ,DATEADD(day, 30, DRUG_EXPOSURE_END_DATE)
                  ,1 AS EVENT_TYPE
                  ,NULL
               FROM #drugTarget D
               ) RAWDATA
            ) E
         WHERE 2 * E.START_ORDINAL - E.OVERALL_ORD = 0
         ) E ON DE.PERSON_ID = E.PERSON_ID
         AND E.END_DATE >= DE.DRUG_EXPOSURE_START_DATE
      GROUP BY de.person_id
         ,de.drug_exposure_start_date
      ) ENDS
   GROUP BY ENDS.person_id
      ,ENDS.era_end_date
   ) ERAS ON ERAS.person_id = et.person_id
WHERE et.start_date BETWEEN ERAS.era_start_date
      AND ERAS.era_end_date;

TRUNCATE TABLE #drugTarget;

DROP TABLE #drugTarget;

-- generate cohort periods into #final_cohort
WITH cohort_ends (
   event_id
   ,person_id
   ,end_date
   )
AS (
   -- cohort exit dates
   -- By default, cohort exit at the event's op end date
   SELECT event_id
      ,person_id
      ,op_end_date AS end_date
   FROM #included_events
   
   UNION ALL
   
   -- End Date Strategy
   SELECT event_id
      ,person_id
      ,end_date
   FROM #strategy_ends
   
   UNION ALL
   
   -- Censor Events
   SELECT i.event_id
      ,i.person_id
      ,MIN(c.start_date) AS end_date
   FROM #included_events i
   INNER JOIN (
      -- Begin Drug Exposure Criteria
      SELECT C.person_id
         ,C.drug_exposure_id AS event_id
         ,C.drug_exposure_start_date AS start_date
         ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, DRUG_EXPOSURE_START_DATE), 
            DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS end_date
         ,C.visit_occurrence_id
         ,C.drug_exposure_start_date AS sort_date
      FROM (
         SELECT de.*
         FROM dbo.DRUG_EXPOSURE de
         INNER JOIN #Codesets codesets ON (
               (
                  de.drug_concept_id = codesets.concept_id
                  AND codesets.codeset_id = 14
                  )
               )
         ) C
         -- End Drug Exposure Criteria
      ) C ON C.person_id = I.person_id
      AND C.start_date >= I.start_date
      AND C.START_DATE <= I.op_end_date
   GROUP BY i.event_id
      ,i.person_id
   
   UNION ALL
   
   SELECT i.event_id
      ,i.person_id
      ,MIN(c.start_date) AS end_date
   FROM #included_events i
   INNER JOIN (
      -- Begin Drug Exposure Criteria
      SELECT C.person_id
         ,C.drug_exposure_id AS event_id
         ,C.drug_exposure_start_date AS start_date
         ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, DRUG_EXPOSURE_START_DATE), 
            DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS end_date
         ,C.visit_occurrence_id
         ,C.drug_exposure_start_date AS sort_date
      FROM (
         SELECT de.*
         FROM dbo.DRUG_EXPOSURE de
         INNER JOIN #Codesets codesets ON (
               (
                  de.drug_concept_id = codesets.concept_id
                  AND codesets.codeset_id = 6
                  )
               )
         ) C
         -- End Drug Exposure Criteria
      ) C ON C.person_id = I.person_id
      AND C.start_date >= I.start_date
      AND C.START_DATE <= I.op_end_date
   GROUP BY i.event_id
      ,i.person_id
   
   UNION ALL
   
   SELECT i.event_id
      ,i.person_id
      ,MIN(c.start_date) AS end_date
   FROM #included_events i
   INNER JOIN (
      -- Begin Drug Exposure Criteria
      SELECT C.person_id
         ,C.drug_exposure_id AS event_id
         ,C.drug_exposure_start_date AS start_date
         ,COALESCE(C.DRUG_EXPOSURE_END_DATE, DATEADD(day, C.DAYS_SUPPLY, DRUG_EXPOSURE_START_DATE), 
            DATEADD(day, 1, C.DRUG_EXPOSURE_START_DATE)) AS end_date
         ,C.visit_occurrence_id
         ,C.drug_exposure_start_date AS sort_date
      FROM (
         SELECT de.*
         FROM dbo.DRUG_EXPOSURE de
         INNER JOIN #Codesets codesets ON (
               (
                  de.drug_concept_id = codesets.concept_id
                  AND codesets.codeset_id = 5
                  )
               )
         ) C
         -- End Drug Exposure Criteria
      ) C ON C.person_id = I.person_id
      AND C.start_date >= I.start_date
      AND C.START_DATE <= I.op_end_date
   GROUP BY i.event_id
      ,i.person_id
   )
   ,first_ends (
   person_id
   ,start_date
   ,end_date
   )
AS (
   SELECT F.person_id
      ,F.start_date
      ,F.end_date
   FROM (
      SELECT I.event_id
         ,I.person_id
         ,I.start_date
         ,E.end_date
         ,row_number() OVER (
            PARTITION BY I.person_id
            ,I.event_id ORDER BY E.end_date
            ) AS ordinal
      FROM #included_events I
      INNER JOIN cohort_ends E ON I.event_id = E.event_id
         AND I.person_id = E.person_id
         AND E.end_date >= I.start_date
      ) F
   WHERE F.ordinal = 1
   )
SELECT person_id
   ,start_date
   ,end_date
INTO #cohort_rows
FROM first_ends;

WITH cteEndDates (
   person_id
   ,end_date
   )
AS -- the magic
   (
   SELECT person_id
      ,DATEADD(day, - 1 * 0, event_date) AS end_date
   FROM (
      SELECT person_id
         ,event_date
         ,event_type
         ,MAX(start_ordinal) OVER (
            PARTITION BY person_id ORDER BY event_date
               ,event_type ROWS UNBOUNDED PRECEDING
            ) AS start_ordinal
         ,ROW_NUMBER() OVER (
            PARTITION BY person_id ORDER BY event_date
               ,event_type
            ) AS overall_ord
      FROM (
         SELECT person_id
            ,start_date AS event_date
            ,- 1 AS event_type
            ,ROW_NUMBER() OVER (
               PARTITION BY person_id ORDER BY start_date
               ) AS start_ordinal
         FROM #cohort_rows
         
         UNION ALL
         
         SELECT person_id
            ,DATEADD(day, 0, end_date) AS end_date
            ,1 AS event_type
            ,NULL
         FROM #cohort_rows
         ) RAWDATA
      ) e
   WHERE (2 * e.start_ordinal) - e.overall_ord = 0
   )
   ,cteEnds (
   person_id
   ,start_date
   ,end_date
   )
AS (
   SELECT c.person_id
      ,c.start_date
      ,MIN(e.end_date) AS end_date
   FROM #cohort_rows c
   INNER JOIN cteEndDates e ON c.person_id = e.person_id
      AND e.end_date >= c.start_date
   GROUP BY c.person_id
      ,c.start_date
   )
SELECT person_id
   ,min(start_date) AS start_date
   ,end_date
INTO #final_cohort
FROM cteEnds
GROUP BY person_id
   ,end_date;

--DELETE FROM Results.test_legend_cohort where cohort_definition_id = @target_cohort_id;
--INSERT INTO Results.test_legend_cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
SELECT 69 AS cohort_definition_id
   ,person_id
   ,start_date
   ,end_date
FROM #final_cohort CO;

TRUNCATE TABLE #strategy_ends;

DROP TABLE #strategy_ends;

TRUNCATE TABLE #cohort_rows;

DROP TABLE #cohort_rows;

TRUNCATE TABLE #final_cohort;

DROP TABLE #final_cohort;

TRUNCATE TABLE #inclusion_events;

DROP TABLE #inclusion_events;

TRUNCATE TABLE #qualified_events;

DROP TABLE #qualified_events;

TRUNCATE TABLE #included_events;

DROP TABLE #included_events;

TRUNCATE TABLE #Codesets;

DROP TABLE #Codesets;