/********************************************************************************
Dynamic Product Storage Type Assignment.

John Fiocca
Thu Dec 19 19:59:08 EST 2024
********************************************************************************/

/*
This is a scalable method of assigning items to the best-available storage location.
The advanced, denormalized SQL techniques used allow you to do this without breaching BigQuery's memory limits.
*/

/********************************************************************************
Site-Level Functions
********************************************************************************/
CREATE TEMP FUNCTION get_storage_priority(storage_type STRING)
RETURNS INT64 AS (
  CASE storage_type
    WHEN 'Fast' THEN 0
    WHEN 'Moderate' THEN 1
    WHEN 'Slow' THEN 2
  END
);


CREATE TEMP FUNCTION get_best_storage_option(
    item_storage_type STRING,
    site_storage_types ARRAY<STRUCT<storage_type STRING, storage_priority_cascade INT64>>
)
RETURNS STRING AS (
  (
  SELECT
    st.storage_type,
  FROM
    UNNEST(site_storage_types) AS st
  WHERE
    /* Looking up the fastest site that the item fits in.
        Note:
          It's greater than or equal to because we start ranking with zero.
          Slower types have higher rankings.
    */
    st.storage_priority_cascade >= get_storage_priority(item_storage_type)
  /* Take all the sites that fit, order by priority, and select the first. */
  ORDER BY
    st.storage_priority_cascade
  LIMIT
    1
  )
);

/********************************************************************************
Item-Level Functions
********************************************************************************/
CREATE TEMP FUNCTION eligible_for_fast(
  weight FLOAT64,
  cubic_volume FLOAT64
)
RETURNS BOOLEAN AS (
  weight < 3 AND cubic_volume < 20
)
;

CREATE TEMP FUNCTION eligible_for_moderate(
  weight FLOAT64,
  cubic_volume FLOAT64
  )
RETURNS BOOLEAN AS (
  weight < 10 AND cubic_volume < 50
)
;


CREATE TEMP FUNCTION get_item_storage_type(
  weight FLOAT64,
  cubic_volume FLOAT64
)
RETURNS STRING AS (
  CASE
    WHEN eligible_for_fast(weight, cubic_volume) THEN 'Fast'
    WHEN eligible_for_moderate(weight, cubic_volume) THEN 'Moderate'
    ELSE 'Slow'
  END
);

/********************************************************************************
Example Data
********************************************************************************/

CREATE TEMP TABLE site_storage_map AS
-- Note that all sites have a slow site.
-- New York has the fast storage type.
SELECT 'New York' AS site_name, 'Fast' AS storage_type UNION ALL
SELECT 'New York' AS site_name, 'Slow' AS storage_type UNION ALL
-- Los Angeles has the moderate storage type.
SELECT 'Los Angeles' AS site_name, 'Moderate' AS storage_type UNION ALL
SELECT 'Los Angeles' AS site_name, 'Slow' AS storage_type UNION ALL
-- Colorado has all the storage types.
SELECT 'Colorado' AS site_name, 'Fast' AS storage_type UNION ALL
SELECT 'Colorado' AS site_name, 'Moderate' AS storage_type UNION ALL
SELECT 'Colorado' AS site_name, 'Slow' AS storage_type
;

CREATE TEMP TABLE site_storage_prioritized AS
SELECT
  site_name,
  ARRAY_AGG(
    STRUCT(
      storage_type,
      get_storage_priority(storage_type) AS storage_priority
    )
  ) AS storage_cascade_array,
FROM
  site_storage_map
GROUP BY
  ALL
;

CREATE TEMP TABLE item AS
SELECT 100 AS item_id, 2 AS weight, 4 AS cubic_volume, UNION ALL
SELECT 101 AS item_id, 3 AS weight, 7 AS cubic_volume, UNION ALL
SELECT 102 AS item_id, 5 AS weight, 15 AS cubic_volume, UNION ALL
SELECT 103 AS item_id, 5 AS weight, 21 AS cubic_volume, UNION ALL
SELECT 104 AS item_id, 11 AS weight, 2 AS cubic_volume, UNION ALL
SELECT 105 AS item_id, 2 AS weight, 70 AS cubic_volume,
;

/********************************************************************************
Demonstration.
********************************************************************************/

/* Categorize the items. */
SELECT
  *,
  eligible_for_fast(weight, cubic_volume) AS elig_fast,
  eligible_for_moderate(weight, cubic_volume) AS elig_mod,
  get_item_storage_type(weight, cubic_volume) AS item_storage_type
FROM
  item
ORDER BY
  item_id
;

/* All sites and their storage types. */
FOR RECORD IN (
  SELECT * FROM UNNEST(['Fast', 'Moderate', 'Slow']
) AS EXAMPLE_ITEM_STORAGE_TYPE)
  DO
    SELECT
      site_name,
      RECORD.EXAMPLE_ITEM_STORAGE_TYPE AS example_item_type,
      get_best_storage_option(
        RECORD.EXAMPLE_ITEM_STORAGE_TYPE,
        storage_cascade_array) AS best_storage_option,
    FROM
      site_storage_prioritized
    ORDER BY
      site_name
    ;
END FOR
;

/* Assign items for each site. */
SELECT
  item_id,
  weight,
  cubic_volume,
  get_item_storage_type(weight, cubic_volume) AS ideal_storage_type,
  get_best_storage_option(
    get_item_storage_type(weight, cubic_volume),
    storage_cascade_array) AS best_storage_option,
  site_name,
FROM
  site_storage_prioritized
CROSS JOIN
  item
ORDER BY
  item_id,
  site_name
;
