BULK INSERT ESTABELE
FROM 'C:\Temp\ESTABELE1.csv'
WITH 
(
    --FORMAT = 'CSV', 
    FIELDQUOTE = '"',
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
		ERRORFILE = 'C:\Temp\Error_Bulk.txt',
    TABLOCK
)
alter table estabele alter column column5 nvarchar(max)
alter table estabele alter column column17 nvarchar(4000)
alter table estabele alter column column13 nvarchar(4000)
alter table estabele alter column column15 nvarchar(4000)
alter table estabele alter column column30 nvarchar(max)

