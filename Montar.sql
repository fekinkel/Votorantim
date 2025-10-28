
------------------------------------------------------------------------------------------------------------------------
--AUTOR					: FERNANDO KINKEL SEREJO
--DATA					: 19/09/2025
--DEPARTAMENTO			: SEF
--SERVIDOR SQL			: LOCAL
--ASSUNTO				: Montar tabelas conforme o Leioute (AnexoVI-LeiautesRN_RTC_IBSCBS-V1.01.01FigSchema.xlsx)
------------------------------------------------------------------------------------------------------------------------
/*
IF OBJECT_ID('tempdb..#CriarTabelas') IS NOT NULL DROP PROCEDURE #CriarTabelas

create procedure #CriarTabelas(@INI as int output, @FIN as int, @tab as varchar(100), @cam as varchar(255), @retornoCampos as varchar(max), @QdeCampos as int output, @campoFKn as varchar(max), @nivel as int)
as
begin
Declare
		@caminho varchar(max),
		@campo varchar(max),
		@ele varchar(max),
		@tipo varchar(max),
		@ocor varchar(max),
		@tam varchar(max),

		@tipoCampo varchar(max),		
		@tabcam varchar(200),
		@tabAntes varchar(max) = '',
		@nCreate varchar(max) = @retornoCampos, 
		@retCampos varchar(max),
		@contador int = 0	,
		@retQdeCampos int,		
		@fks varchar(max) = '',
		@w varchar(max),
		@mermaid varchar(max)

	Select @w = ([Caminho no XML]) From #temp Where Num = @ini
	Print 'Aqui tab ' + @tab + ' @cam ' + @cam + ' [Caminho no XML] ' + @w
	While (Len(@cam) <= (Select Len([Caminho no XML]) From #temp Where Num = @ini)) AND (@ini <= @Fin)
	Begin

		Select @caminho = [Caminho no XML], @ele = ELE, @campo = CAMPO, @tipo = tipo, @ocor = OCOR#, @tam = case when charindex('-', TAM#)>0 then SUBSTRING(TAM#, charindex('-', TAM#)+1, len(TAM#)) else TAM# end
		From #temp
		Where Num = @ini	

		SELECT @tipocampo =
    CASE @tipo
        WHEN 'C' THEN 
            'varchar(' + 
            CASE 
                WHEN @tam = '4V2' THEN '20'
                ELSE @tam
            END + ')'

        WHEN 'CE' THEN 
            'varchar(' + @tam + ')'

        WHEN 'N' THEN 
            CASE
								WHEN  @tam = '1V2' THEN 'decimal(2,2)' 
                WHEN CHARINDEX('V', @tam) > 0 THEN
                    'decimal(' + 
                        LEFT(@tam, CHARINDEX('V', @tam) - 1) + ',' + 
                        RIGHT(@tam, LEN(@tam) - CHARINDEX('V', @tam)) + 
                    ')'
                
                ELSE
                    'int'
            END
    END
		From #temp
		Where Num = @ini		

		if (@ini = 0) 
		begin			
			set @campo = @tab
			set @tabcam = 'TC' + UPPER(LEFT(@Tab, 1)) + SUBSTRING(@tab, 2, LEN(@tab))
		end
		else
		begin
			 set @tabcam = 'TC' + UPPER(LEFT(@campo, 1)) + SUBSTRING(@campo, 2, LEN(@campo))
		end
		if(Charindex('TCValores', @tabcam)>0)
		Begin
			if(Charindex('dps', @caminho)>0)
			Begin
				Select @tabcam = Replace(@tabcam, 'TCV', 'TCDpsV')
			End
			Else
			Begin
				if(Charindex('IBSCBS', @caminho)>0)
				Begin
					Select @tabcam = Replace(@tabcam, 'TCV', 'TCIbsCbsV')
				End
				Else
				Begin
					Select @tabcam = Replace(@tabcam, 'TCV', 'TCNfseV')
				End
			End
		End
		set @ini = @ini + 1

		if(select @ELE ) in ('G', 'CG', 'Raiz') 
		begin
			set @caminho = @caminho + @campo + '/'
			--Select 
			--	MAX(Case when (value in (0,1)  and Linha = 2) then 1 Else 0 end) as Tab,
			--	MAX(Case when (value = 0 and Linha = 1) then 'NULL' Else 'NOT NULL' end) as Regra
			--From(
			--	Select  value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Linha
			--	From string_split(@ocor, '-'))	as TAB
			Select @retCampos = 'IF OBJECT_ID(' + char(39) + @tabcam + Char(39) + ') IS NULL ' +
			'CREATE TABLE ' + @tabcam + '(' + Char(10) +
			'	Id INT PRIMARY KEY IDENTITY(1,1), ' + Char(10) 

			--Montar a FOREIGN KEY
			IF OBJECT_ID('tempdb..#fk') IS NOT NULL DROP TABLE #fk
			Select 
				MAX(Case when (value in (retCampos,1)  and Linha = 2) then 1 Else 0 end) as Tab,
				MAX(Case when (value = 0 and Linha = 1) then 'NULL' Else 'NOT NULL' end) as Regra
			Into #fk
			From(
				Select  value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Linha
				From string_split(@ocor, '-'))	as TAB
			If(Select tab From #fk) = 1
			Begin
				set @fks = ''
				if(@tabcam <> '' and (charindex(@tabcam, @tabantes) = 0) ) select @tabantes = @tabantes + @tabcam + 'Id INT ' + regra  + ',' From #fk
			End
			else
			Begin
				Select @fks = @tab + 'Id INT ' + regra + ','
				From #fk 
			end

			
			select @nivel = @nivel + 1
			print 'Estou na tabela: ' + @tab + '('+ @ocor +')' +' e Entrar na tabela: ' + @tabcam	+ ' Lista FKn: ' + @fks + ' FK_1: ' + @tabantes
			exec #CriarTabelas @ini output, @fin, @tabcam, @caminho, @retCampos, @retQdeCampos output, @fks, @nivel

			--print 'Sair da tabela : ' + @tabcam	+ ' e estou na Tabela: ' + @tab
			
			set @nivel = @nivel - 1
		end
		else
		begin
			--print 'Criando os Campos da tabela: '
			if(@campo = 'Id')
			Begin
				 Select @campo = @campo + @tab
			End
			set @contador = @contador + 1
			
			Select @nCreate = @nCreate + '	'	+ @campo + '  ' + IsNull(@tipocampo, 'Int') + ' ' + Case @ocor when '0-1' then 'NULL' else 'NOT NULL' end +', ' + Char(10)

			--print @nCreate
		end
	End
	--if (Select Charindex('TCFed', @tabantes)) > 0 print @tabantes
	DECLARE @s VARCHAR(MAX) =   @tabantes + @campoFKn
	--Print 'FKs : ' + @s + '  Tabela : ' + @tab
	if(@s <> '')
	begin
		--print 'FKs: ' + @tabantes		 

		;WITH cte AS (
		    SELECT 
		        LTRIM(RTRIM(value)) AS value,
		        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
		        COUNT(*) OVER () AS total
		    FROM STRING_SPLIT(@s, ',')
		    WHERE NULLIF(LTRIM(RTRIM(value)), '') IS NOT NULL
		)
		SELECT
				@nCreate = @nCreate +  		    
		    STRING_AGG('    ' + value + ',', CHAR(10)) + 
		    STRING_AGG('    FOREIGN KEY (' + Substring(value,1,CharIndex(' ', value)) + ') REFERENCES ' + Substring(value,1,CharIndex(' ', value)-3) + '(Id),', CHAR(10)) + CHAR(10) +
		    ');'
		FROM cte;
	end
	else
	begin
		 Select @nCreate = Substring(@nCreate, 1, len(@nCreate)-3) + '); ' + char(10)
	end

	--print Convert(varchar(20),@ini) + ' ) Criado todos os campos da Tabela: ' + @tab + ' - Campos: ' + @nCreate
	Insert Into #result Values (@nCreate, @tab, @nivel)
	select @QdeCampos  = @contador
	
	
end

*/

									
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result

SELECT identity(int,1,1) as Num, * 
Into #temp
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
  'Excel 12.0 Xml;Database=C:\Temp\RN_RTC_IBSCBS_V1_01_02.xlsx;', Leiaute_DPS_NFS$)
Where Campo is not null

Create Table #result (Num int identity(1,1), resultado varchar(max), tabela varchar(200), nivel int)  
declare 
@create varchar(max) = ''

exec #CriarTabelas 2, 446, '', '', @create	, '','', 0

declare 
--@create varchar(max) = '',
@i int = 1,
@s varchar(max)

While (@i < = (select max(num) From #result))
Begin
	BEGIN TRY
		Select @create = resultado From #result Where Num = @i
		--select @create
		Exec(@create )
	END TRY
	BEGIN CATCH
	 			Select @s=tabela From #result where Num = @i
        PRINT 'Erro no item ' + CAST(@i AS VARCHAR(10)) +
				' na tabela ' + (@s ) + 
              ': ' + ERROR_MESSAGE()
        -- Aqui você pode registrar o erro em uma tabela de log, por exemplo
    END CATCH
	Set @i = @i + 1
End

--declare 
--@create varchar(max) = ''
--Select @create = resultado 
Select resultado 
From #result Where tabela like 'TCInfNfse%'
--Exec(@create )

Select * From #result
--Select * From #temp
--ROTINA PARA EXCLUIR AS TABELAS
/*
IF OBJECT_ID('tempdb..#del') IS NOT NULL DROP TABLE #del

select Identity(int,1,1) as Num, tabela Into #del from #result	--where nivel >=2
declare 
@s varchar(100),
@d int = 1

While (@d <= (Select max(num) from #del) )
Begin	
	Begin Try
	 Select top 1 @s = 'Drop Table ' + tabela  From #del 
	 Where Num = @d 
	 Exec(@s)
	 --Select @s
	End Try
	Begin Catch
		Print 'Error'  + ERROR_MESSAGE()
	End Catch
	 Set @d = @d + 1
End
*/

/*
SELECT name
FROM sys.tables
ORDER BY name;
*/