/* 
This is useful when you need to sort a table by a column that has both text, numerical, and alphanumeric names

Example: Need a sorted dimension table which appropriately sorts values when dropped into a matrix as rows.
Power BI lets you sort a column by a different column, this is how you can create that column in a scenario like the one described above.
*/

-- common table expression to seperate and order all text only values alphabetically
WITH txt_only AS (
SELECT
	-- use row number function to assign a order number based on text column
	ROW_NUMBER() OVER(ORDER BY YardName) as ORDERNUM,
	Yard_GUID,
	State,
	YardName
FROM UHBYards
WHERE State = 'California')

-- use cte
SELECT
	*
FROM txt_only

UNION
-- non text values, with order number beginning with ending of text values
SELECT
	ORDERNUM = txt.txtMAX + ROW_NUMBER() OVER(ORDER BY case when CHARINDEX('B',YardName) = 0 then CAST(YardName as int) else CAST(REPLACE(YardName, 'B', '') as int) end),
	Yard_GUID,
	State,
	YardName
FROM UHBYards
-- use the max order num from cte to obtain starting point
OUTER APPLY (SELECT MAX(ORDERNUM) as txtMAX from txt_only) txt
WHERE State = 'North Dakota'