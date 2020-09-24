-- I created this query to output the results of a query to a file that will be used to 
-- by a DOS program (yes DOS) and can not read line over 255 characters long
-- so I output the each field of every record to a new line delimited with 
-- ---start--- and ---end-- 
-- I used a scheduled task on the SQL server to run a sqlcmd that uses this sql to out put the results to a text file
-- turn off resluts count by turning nocount off
-- only programmers would have you turn something on by turning it off
SET NOCOUNT ON 
-- Declare all my variables 
-- rowcount holds the total number of records or rows
-- counter holds the current row
-- parts holds the results of my query in text format 
DECLARE @rowcount int
DECLARE @counter int
DECLARE @parts varchar(MAX)
-- checks to see if a temporary table with the name of tempgfx is in memory
-- If it is it deletes it
IF OBJECT_ID('tempdb..#tempgfx') IS NOT NULL
    DROP TABLE #tempgfx
-- create the temporary table from scratch
CREATE TABLE #tempgfx(
-- This field is used as a way of tracking what record we are on
-- The identity(1,1) means that it will automatically increment by 1 starting at 1
ID int IDENTITY(1,1) PRIMARY KEY,
Start nvarchar(40),
WOID nvarchar(40),
QID nvarchar(40),
EntryDt nvarchar(40),
EntryID nvarchar(40),
SchdShpDt nvarchar(40),
[Admin$] nvarchar(40),
CID nvarchar(40),
RepID nvarchar(40),
ShpDt nvarchar(40),
OrderDesk nvarchar(40),
NoChgAprv nvarchar(40),
CommNo nvarchar(40),
OrderDeskDt nvarchar(40),
IMGNo nvarchar(40),
Qty nvarchar(40),
PartNo nvarchar(40),
Sizes nvarchar(40),
IVPH nvarchar(40),
VMN nvarchar(40),
FB nvarchar(40),
Art_WID nvarchar(40),
[File] nvarchar(40),
Printed nvarchar(40),
Laminated nvarchar(40),
SQFT nvarchar(40),
Price nvarchar(40),
[Desc] nvarchar(150),
LeadTime nvarchar(40),
[End] nvarchar(40)
)
-- This loads the temp table with the information I want to print out
-- It is a simple join query with a date parameters ordered by the WOID field  
INSERT INTO #tempgfx(
Start,
WOID,
QID,
EntryDt,
EntryID,
SchdShpDt,
[Admin$],
CID,
RepID,
ShpDt,
OrderDesk,
NoChgAprv,
CommNo,
OrderDeskDt,
IMGNo,
Qty,
PartNo,
Sizes,
IVPH,
VMN,
FB,
Art_WID,
[File],
Printed,
Laminated,
SQFT,
Price,
[Desc],
LeadTime,
[End]
)
-- Here's the query that pulls the data I want
-- It convert all the fields to text and puts quotes around the content of the fields
-- I added a start and end field to use in parsing the records later
SELECT
    '---Start---' as Start,
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.WOID),'NULL') + '"' as WOID,
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.QID),'NULL') + '"' as QID,
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.EntryDt, 1), 'NULL') + '"' as EntryDt, 
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.EntryID),'NULL') + '"' as EntryID,
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.SchdShpDt, 1), 'NULL') + '"' as SchdShpDt, 
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.Admin$),'NULL') + '"' as [Admin$],
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.CID),'NULL') + '"' as CID,
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.RepID),'NULL') + '"' as RepID,
 '"' + ISNULL(CONVERT(nVarChar(30),GWO.ShpDt, 1), 'NULL') + '"' as ShpDt, 
 '"' + ISNULL(convert(nVarChar(30),GWO.OrderDesk),'NULL') + '"' as OrderDesk,
 '"' + ISNULL(convert(nVarChar(30),GWO.NoChgAprvl),'NULL') + '"' as NoChgAprv,
 '"' + ISNULL(convert(nVarChar(30),GWO.CommNo),'NULL') + '"' as CommNo,
 '"' + ISNULL(convert(nVarChar(30),GWO.OrderDeskDt, 1),'NULL') + '"' as OrderDeskDt,
 '"' + ISNULL(convert(nVarChar(30),GPT.IMGNo),'NULL') + '"' as IMGNo,
 '"' + ISNULL(convert(nVarChar(30),GPT.Qty),'NULL') + '"' as Qty,
 '"' + ISNULL(convert(nVarChar(30),GPT.PartNo),'NULL') + '"' as PartNo,
 '"' + ISNULL(convert(nVarChar(30),GPT.Sizes),'NULL') + '"' as Sizes,
 '"' + ISNULL(convert(nVarChar(30),GPT.IVPH),'NULL') + '"' as IVPH,
 '"' + ISNULL(convert(nVarChar(30),GPT.VMN),'NULL') + '"' as VMN,
 '"' + ISNULL(convert(nVarChar(30),GPT.FB),'NULL') + '"' as FB,
 '"' + ISNULL(convert(nVarChar(30),GPT.Art_WID),'NULL') + '"' as Art_WID,
 '"' + ISNULL(convert(nVarChar(30),GPT.[File]),'NULL') + '"' as [File],
 '"' + ISNULL(convert(nVarChar(30),GPT.Printed),'NULL') + '"' as Printed,
 '"' + ISNULL(convert(nVarChar(30),GPT.Laminated),'NULL') + '"' as Laminated,
 '"' + ISNULL(convert(nVarChar(30),GPT.SQFT),'NULL') + '"' as SQFT,
 '"' + ISNULL(convert(nVarChar(30),GPT.Price),'NULL') + '"' as Price, 
 '"' + ISNULL(convert(nVarChar(100),GPT.[Desc]),'NULL') + '"' as [Descript], 
 '"' + ISNULL(convert(nVarChar(30),GPT.LeadTime),'NULL') + '"' as LeadTime,
 '---END---' as [End]
FROM dbo.GFX_Order GWO
 JOIN dbo.GFX_Parts GPT on GWO.WOID = GPT.GFX_ID
-- Here's the data parameter 
-- It gets every records after 1/1/2010
WHERE GWO.EntryDt >'2010-1-1 00:00:00.000'
-- Here's where the results get ordered by the WOID field
order by GWO.WOID
-- This is where the real output part begins
-- This puts the total number of records from tempgfx into the rowcount varible 
SELECT @ROWCOUNT = MAX(ID) FROM #tempgfx
-- print @rowcount
-- This sets the counter to the first record 
-- Normally this would be zero in the database but I added a record number field 
-- and it automatically increments by 1 starting with 1
SET @counter = 1
-- This is where we loop thru the results
-- If the row if less than or equal to the total number of rows then go to the 
-- next record.
-- If not exit this loop
WHILE @counter <= @rowcount
BEGIN

-- print @counter
-- Stuff was added to remove the first comma from the results and put it the results of the 
-- query into the parts variable

 SELECT
 @parts = STUFF((
 SELECT
 -- I added the new line break to each field
 -- The first one is done using the hexi decimal format
 -- That is the CHAR(0x0A) part
 Start + CHAR(0x0A),
 -- This is the key field 
 -- I converted to text and then put quotes around
 '"' + ISNULL(CONVERT(nVarChar(30),ID),'NULL') + '"' + CHAR(10),
 WOID + CHAR(10),
 QID+ CHAR(10),
 EntryDt + CHAR(10), 
 EntryID+ CHAR(10),
 SchdShpDt + CHAR(10), 
 [Admin$] + CHAR(10),
 CID + CHAR(10),
 RepID + CHAR(10),
 ShpDt + CHAR(10), 
 OrderDesk + CHAR(10),
 NoChgAprv + CHAR(10),
 CommNo + CHAR(10),
 OrderDeskDt + CHAR(10),
 IMGNo + CHAR(10),
 Qty + CHAR(10),
 PartNo + CHAR(10),
 Sizes + CHAR(10),
 IVPH + CHAR(10),
 VMN + CHAR(10),
 FB + CHAR(10),
 Art_WID + CHAR(10),
 [File] + CHAR(10),
 Printed + CHAR(10),
 Laminated + CHAR(10),
 SQFT + CHAR(10),
 Price + CHAR(10),
 [Desc] + CHAR(10),
 LeadTime + CHAR(10),
 '---END---'
 FROM #tempgfx where ID = @counter
 FOR XML PATH('')),1,1,'');
-- This prints out the record fields or parts to file
print @parts
-- This resets my part to nothing
SET @parts = ''
-- Adds one to the row
SET @counter = @counter + 1
-- If we're done exit out of the loop
END
-- Deletes the temp table from memory
DROP TABLE #tempgfx
-- And we are done
