/* Archival and resampling of ephemeral data. */
BEGIN

  CREATE TEMP TABLE temp_table AS
  SELECT * FROM `project.dataset.live_table`;

  CREATE TEMP TABLE record_snapshot AS
  SELECT
    *,
    /* If using scheduler
    @run_date AS run_date,
    @run_time AS run_time,
    */
    CURRENT_DATE AS run_date,
    CURRENT_TIMESTAMP AS run_time,
  FROM
    temp_table;

  /* `T` and `S` are conventions for target and source respectively. */
  MERGE INTO `project.dataset.live_table_archive` AS T
  USING record_snapshot AS S
  ON
    TRUE
    AND T.id1 = S.id1
    AND T.id2 = S.id2
    -- Avoid duplicates where `NULL = NULL` evaluates to `NULL`, not `TRUE`.
    AND (T.id3 = S.id3 OR (T.id3 IS NULL AND S.id3 IS NULL))
  WHEN NOT MATCHED THEN
    INSERT ROW
  ;

END
;

/* Resample to a daily level to generate values between the snapshots. */
CREATE OR REPLACE VIEW `project.dataset.live_table_archive__daily` AS
SELECT
  *
FROM
  UNNEST(GENERATE_DATE_ARRAY('2000-01-01', '2050-01-01')) AS ds -- Could use MIN MAX subquery of source.
INNER JOIN (
  SELECT
    *,
    LEAD(record_date) OVER (PARTITION BY a, b, c ORDER BY record_date) AS next_record_date,
  FROM
    `project.dataset.live_table_archive`
  QUALIFY
    1 = ROW_NUMBER() OVER (PARTITION BY a, b, c ORDER BY status DESC)
) AS archive
ON
  ds BETWEEN archive.record_date AND coalesce(archive.next_record_date, CURRENT_DATE)
;