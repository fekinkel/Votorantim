Declare
@Path VARCHAR(255) = 'D:\Temp\Downloads',
@Filename VARCHAR(100) ='K3241.K03200Y8.D50111.ESTABELE',		--K3241.K03200Y7.D50111.ESTABELE --K3241.K03200Y8.D50111.ESTABELE
@tabela varchar(100) = 'ESTABELECIMENTO',
@col varchar(4000) = '(',
@exec varchar(4000)

SET NOCOUNT on

select @col = @col + b.name +	', '
from sys.objects a
inner join sys.columns b on b.object_id = a.object_id
Where a.name = @tabela

select @col = substring(@col, 1, len(@col) -1) +')'

DECLARE @objFileSystem int,
        @objTextStream int,
				@objErrorObject int,					 02 
				@strErrorMessage Varchar(1000),
				@Command varchar(1000),
				@hr int,
				@String VARCHAR(8000),
				@Valor varchar(8000),
				@YesOrNo INT

select @strErrorMessage='opening the File System Object'
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT


if @HR=0 Select @objErrorObject=@objFileSystem, @strErrorMessage='Opening file "'+@path+'\'+@filename+'"',@command=@path+'\'+@filename

if @HR=0 execute @hr = sp_OAMethod   @objFileSystem  , 'OpenTextFile'
, @objTextStream OUT, @command,1,false,0--for reading, FormatASCII

select @Command

WHILE @hr=0
BEGIN
	--if @HR=0 Select @objErrorObject=@objTextStream, @strErrorMessage='finding out if there is more to read in "'+@filename+'"'
	
	--if @HR=0 execute @hr = sp_OAGetProperty @objTextStream, 'AtEndOfStream', @YesOrNo OUTPUT

	--IF @YesOrNo<>0  break
	
	--if @HR=0 Select @objErrorObject=@objTextStream, @strErrorMessage='reading from the output file "'+@filename+'"'

	if @HR=0 execute @hr = sp_OAMethod  @objTextStream, 'Readline', @String OUTPUT
	Select @Valor = @String
	Select @String = Replace(@String, Char(39), '"')
	Select @String = Char(39) + REPLACE(@string, '";"', Char(39) + ', ' + Char(39))
	Select @String = '(' + Char(39) + Substring(@String, 3, Len(@String)-3) + Char(39)  + ')'
	Select @exec = 'INSERT INTO ' + @Tabela + @col + 'VALUES '+ @String

	BEGIN TRY
    if @hr = 0 Exec (@exec)
	END TRY
	BEGIN CATCH
    Insert Into ERRO Select @tabela, @exec, @Valor
	END CATCH
	

	--Select @hr, @exec

	--INSERT INTO @file(line) SELECT @String
END

--INSERT INTO ESTABELE(column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23, column24, column25, column26, column27, column28, column29, column30)VALUES ('07396865', '0001', '68', '1', '', '08', '20170210', '01', '', '', '20050518', '1412602', '1411801', 'RUA', 'TUCANEIRA', '30', '', 'DOS LAGOS', '89136000', 'SC', '8297', '47', '33851125', '47', '33851125', '47', '33851125', '', '', '')

 
