/*****************************************************************************
"Help! I don't know Vim and I need to query the IDs in this spreadsheet!"
John Fiocca

Use this technique instead of pasting into an online formatter, please.

You'll have to change the `project` and `dataset` names for your BQ instance.
*****************************************************************************/

CREATE OR REPLACE PROCEDURE `project.dataset.id_csv`(IN id_list_from_spreadsheet STRING, OUT id_csv_string STRING)
BEGIN
  SET id_csv_string = (
    SELECT
      STRING_AGG(TRIM(id), ',')
    FROM
      UNNEST(SPLIT(id_list_from_spreadsheet, '\n')) AS id
    WHERE
      REGEXP_REPLACE(id, r'[\t\f\r ]', '') <> ''
    );
END;

/* The procedure requires an output parameter: just declare some string variable */
DECLARE output STRING;

/* Copy the values from the spreadsheet and paste between the triple quotes. */
CALL `project.dataset.id_csv`(
"""
123
abc
you and me
""", output);

/* Now you can reformat for whatever input you require. */
SELECT output; -- Copy/Paste this instead of using those online CSV formatters.
SELECT SPLIT(output, ','); -- Array of values for denormalized querying.
SELECT * FROM UNNEST(SPLIT(output, ',')) AS id; -- Simple one-column table output.