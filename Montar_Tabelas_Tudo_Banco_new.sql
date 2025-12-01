
------------------------------------------------------------------------------------------------------------------------
--AUTOR					: FERNANDO KINKEL SEREJO
--DATA					: 19/09/2025
--DEPARTAMENTO	: SEF
--SERVIDOR SQL	: LOCAL
--ASSUNTO				: Montar tabelas conforme o Leiaute (AnexoVI-LeiautesRN_RTC_IBSCBS-V1.01.02.xlsx)
------------------------------------------------------------------------------------------------------------------------
/*
IF OBJECT_ID('tempdb..#CriarTabelas') IS NOT NULL DROP PROCEDURE #CriarTabelas

create procedure #CriarTabelas(@INI as int output, @FIN as int, @tab as varchar(100), @tabold as varchar(100), @cam as varchar(255), @retornoCampos as varchar(max), @retornoCamposMer as varchar(max), @QdeCampos as int output, @campoFKnBanco as varchar(max), @campoFKnMermaid as varchar(max), @nivel as int, @tabanterior as varchar(max))
as
begin
Declare
	@caminho varchar(max),
	@campo varchar(max),
	@ele varchar(max),
	@tipo varchar(max),
	@ocor varchar(max),
	@tam varchar(max),
	@F10 varchar(max),

	@tipocampoBanco varchar(max),
	@tipoCampoMermaid varchar(max),		
	@tabcam varchar(200),
	@tabcamold varchar(200),
	@tabAntesBanco varchar(max) = '',
	@tabAntesMermaid varchar(max) = '',
	@nCreateMermaid varchar(max) = @retornoCamposMer, 
	@nCreateBanco varchar(max) = @retornoCampos, 
	@retCampos varchar(max),
	@retCamposMer varchar(100),
	@contador int = 0	,
	@retQdeCampos int,		
	@fksBanco varchar(max) = '',
	@fksMermaid varchar(max) = '',
	@w varchar(max),
	@mermaid varchar(max),
	@relacao varchar(100)

	Select @w = ([Caminho no XML]) From ##temp Where Num = @ini
	--Print 'Aqui tab ' + @tab + ' @cam ' + @cam + ' [Caminho no XML] ' + @w
	While (Len(@cam) <= (Select Len([Caminho no XML]) From ##temp Where Num = @ini)) AND (@ini <= @Fin)
	Begin

		Select @caminho = [Caminho no XML], @ele = ELE, @campo = CAMPO, @F10 = F10, @tipo = tipo, @ocor = OCOR#, @tam = case when charindex('-', TAM#)>0 then SUBSTRING(TAM#, charindex('-', TAM#)+1, len(TAM#)) else TAM# end
		From ##temp
		Where Num = @ini	
		
		SELECT @tipocampoBanco =
    CASE @tipo
        WHEN 'C' THEN 
            'varchar(' + 
            CASE 
                WHEN @tam = '4V2' THEN '20'
                ELSE @tam
            END + ')'

        WHEN 'CE' THEN 
            'varchar(' + @tam + ')'
        WHEN 'D' THEN 
            'datetime'
        WHEN 'N' THEN 
            CASE
								--WHEN  @tam = '1V2' THEN 'decimal(2,2)' 
                WHEN CHARINDEX('V', @tam) > 0 THEN
                    'decimal(' + 
                        Convert(varchar(max),Convert(int,LEFT(@tam, CHARINDEX('V', @tam) - 1)) + Convert(int,RIGHT(@tam, LEN(@tam) - CHARINDEX('V', @tam)))) + ',' + 
                        RIGHT(@tam, LEN(@tam) - CHARINDEX('V', @tam)) + 
                    ')'
                WHEN @tam >= 13 THEN 'bigint'
                ELSE
                    'int'
            END
    END

		SELECT @tipocampoMermaid =
    CASE @tipo
        WHEN 'C' THEN 
            'string'
        WHEN 'CE' THEN 
            'string'
        WHEN 'D' THEN 
            'datetime'
        WHEN 'N' THEN 
            'decimal'                
        ELSE
            'int'        
    END
		From ##temp
		Where Num = @ini		

		if (@ini = 0) 
		begin			
			set @campo = @tab
			set @tabcam = '' + UPPER(LEFT(@Tab, 1)) + SUBSTRING(@tab, 2, LEN(@tab))
		end
		else
		begin
			 --set @tabcam = '' + UPPER(LEFT(@campo, 1)) + SUBSTRING(@campo, 2, LEN(@campo))
			 set @tabcamold = '' + @campo
			 set @tabcam = '' + UPPER(LEFT(IsNull(@F10,@campo), 1)) + SUBSTRING(IsNull(@F10,@campo), 2, LEN(IsNull(@F10,@campo)))
		end
		set @ini = @ini + 1

		if(select @ELE ) in ('G', 'CG', 'Raiz') 
		begin
			set @caminho = @caminho + @campo + '/'
			Select @retCampos = 'IF OBJECT_ID(' + char(39) + @tabcam + Char(39) + ') IS NULL ' +
			'CREATE TABLE ' + @tabcam + '(' + Char(10) +
			'	Id INT PRIMARY KEY IDENTITY(1,1), ' + Char(10) 

			Select @retCamposMer = @tabcam + '{' + Char(10) +
			'	int Id PK ' + Char(10) 

			--Montar a FOREIGN KEY
			IF OBJECT_ID('tempdb..#fk') IS NOT NULL DROP TABLE #fk
			Select 
				MAX(Case when (value in (@retCamposMer,1)  and Linha = 2) then 1 Else 0 end) as Tab,
				MAX(Case when (value = 0 and Linha = 1)or(substring(@ele,1,1) = 'C') then 'NULL' Else 'NOT NULL' end) as Regra
			Into #fk
			From(
				Select  value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Linha
				From string_split(@ocor, '-'))	as TAB
			If(Select tab From #fk) = 1
			Begin
				set @fksBanco = ''
				set @fksMermaid = ''
				if(@tabcam <> '' and (charindex(@tabcam, @tabantesBanco) = 0) ) select @tabantesBanco = @tabantesBanco + @tabcam + 'Id INT ' + regra  + ',' From #fk
				if(@tabcam <> '' and (charindex(@tabcam, @tabantesMermaid) = 0) ) select @tabantesMermaid = @tabantesMermaid + 'int ' + @tabcam + 'Id FK ' + ',' From #fk
			End
			else
			Begin
				Select @fksBanco = @tab + 'Id INT ' + regra + ',',
							 @fksMermaid = 'int ' + @tab + 'Id ' + ','
				From #fk 
			end
			Insert into #fkchave
			Select @tab, @tabcam, regra, @cam, @nivel
			From #fk

			select @nivel = @nivel + 1
			
			--print 'Estou na tabela: ' + @tab + '('+ @ocor +')' +' e Entrar na tabela: ' + @tabcam	+ ' Lista FKn: ' + @fksBanco + ' FK_1: ' + @tabantesBanco
			select @relacao = 
			Case @ocor
				When '1-1' Then ' ||--|| '
				When '0-1' Then ' o|--|| '
				Else ' ||--|{ ' 
			End
			select @mermaid = @tab + @relacao + @tabcam + ' : ' + @tabold + '-' + @tabcamold
			Insert Into #modelo Values (@mermaid)
			exec #CriarTabelas @ini output, @fin, @tabcam, @tabcamold, @caminho, @retCampos, @retCamposMer, @retQdeCampos output, @fksBanco, @fksMermaid, @nivel, @tab
			
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
			
			--Select @nCreateBanco = @nCreateBanco + '	'	+ @campo + '  ' + IsNull(@tipocampoBanco, 'Int') + ' ' + Case @ocor when '0-1' then 'NULL' else 'NOT NULL' end +', ' + Char(10)
			Select @nCreateBanco = @nCreateBanco + '	'	+ @campo + '  ' + IsNull(@tipocampoBanco, 'Int') + ' ' + Case when (@ocor = '0-1') or (substring(@ele,1,1) = 'C') then 'NULL' else 'NOT NULL' end +', ' + Char(10)

			Select @nCreateMermaid = @nCreateMermaid + '	' + IsNull(@tipocampoMermaid, 'Int') + '  ' + @campo + Char(10)
			--print 'Tabela é ' + @tab + ' a tabela Pai é: ' + @tabold + ' e os campos são: ' + @nCreateBanco 
		end
	End
	

	DECLARE @sMermaid VARCHAR(MAX) =   @tabantesMermaid + @campoFKnMermaid
	DECLARE @sBanco VARCHAR(MAX) =   @tabantesBanco + @campoFKnBanco

	--print '@sMermaid'

	if(@sMermaid is not null and @sMermaid <> '')
	begin		
		;WITH cte AS (
		    SELECT 
		        LTRIM(RTRIM(value)) AS value,
		        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
		        COUNT(*) OVER () AS total
		    FROM STRING_SPLIT(@sMermaid, ',')
		    WHERE NULLIF(LTRIM(RTRIM(value)), '') IS NOT NULL
		)
		SELECT
				@nCreateMermaid = @nCreateMermaid +  		    
		    STRING_AGG('    ' + value , CHAR(10)) +
		    --STRING_AGG('    FOREIGN KEY (' + Substring(value,1,CharIndex(' ', value)) + ') REFERENCES ' + Substring(value,1,CharIndex(' ', value)-3) + '(Id),', CHAR(10)) + CHAR(10) +
		    '}'
		FROM cte;
	end
	else
	begin
		Select @nCreateMermaid = @nCreateMermaid + '}' + char(10)
	end

	Select @sBanco banco, @tab as tab, * From #fkchave where tabpai = @tab
	Select @sBanco banco, @tabcam as tabcam, * From #fkchave where tabfilho = @tabcam
	--delete from #fkchave
	--print 'aqui'
	--if(@sBanco is not null) Print 'Não é nulo @sBanco é : ' + DATALENGTH(@sBanco)

	if(@sBanco is not null and @sBanco <> '')
	begin
		;WITH cte AS (
		    SELECT 
		        LTRIM(RTRIM(value)) AS value,
		        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
		        COUNT(*) OVER () AS total
		    FROM STRING_SPLIT(@sBanco, ',')
		    WHERE NULLIF(LTRIM(RTRIM(value)), '') IS NOT NULL
		)
		SELECT
				@nCreateBanco = @nCreateBanco +  		    
		    STRING_AGG('    ' + value + ',', CHAR(10)) + 
		    STRING_AGG('    FOREIGN KEY (' + Substring(value,1,CharIndex(' ', value)) + ') REFERENCES ' + Substring(value,1,CharIndex(' ', value)-3) + '(Id) ON DELETE CASCADE,', CHAR(10)) + CHAR(10) +
		    ');'
		FROM cte;
	end
	else
	begin
		 Select @nCreateBanco = Substring(@nCreateBanco, 1, len(@nCreateBanco)-3) + '); ' + char(10)
	end

	Insert Into #result Values (@nCreateBanco, @nCreateMermaid, @tab, @nivel)
	select @QdeCampos  = @contador
	
	--print 'Saindo tab: ' + @tab + ' tabela anterior: ' + @tabanterior + ' create: ' + @nCreateBanco
	print 'Saindo tab: ' + @tab + ' tabela anterior: ' + @tabanterior + ' xls: ' + @tabold
end

*/

Declare 
--@xls varchar(200) = 'C:\Temp\RN_RTC_IBSCBS_V1_00_00.xlsx',
--@xls_plan varchar(200) = 'Leiaute_EVENTO$',
--@xsd varchar(200) = 'C:\Temp\PL_NFSE_NT04_RTCv101\tiposEventos_v1.00.xsd',
@xls varchar(200) = 'C:\Temp\RN_RTC_IBSCBS_V1_00_00.xlsx',
@xls_plan varchar(200) = 'Leiaute_DPS_NFS$',
@xsd varchar(200) = 'C:\Temp\PL_NFSE_NT04_RTCv101\tiposComplexos_v1.00.xsd',
--@xls varchar(200) = 'C:\Temp\RN_RTC_IBSCBS_V1_01_02.xlsx',
--@xls_plan varchar(200) = 'Leiaute_DPS_NFS$',
--@xsd varchar(200) = 'C:\Temp\PL_NFSE_NT04_RTCv101\tiposComplexos_v1.01.xsd',
@sql varchar(max)

IF OBJECT_ID('tempdb..##complextype') IS NOT NULL DROP TABLE ##complextype
IF OBJECT_ID('tempdb..##tabelement') IS NOT NULL DROP TABLE ##tabelement
IF OBJECT_ID('tempdb..#depara') IS NOT NULL DROP TABLE #depara
IF OBJECT_ID('tempdb..#deparaCam') IS NOT NULL DROP TABLE #deparaCam
IF OBJECT_ID('tempdb..#fkchave') IS NOT NULL DROP TABLE #fkchave

Select	1000 as Linha,
				replicate('x',100) as DE,
				replicate('x',100) as PARA,
				replicate('x',100) as PAI
Into #depara
Where 1 = 0

Select 
				replicate ('x', 100) as tabPai,
				replicate ('x', 100) as tabFilho,
				replicate ('x', 100) as tabChave,
				replicate ('x', 255) as caminho,
				1 as nivel
Into #fkchave
Where 1 = 0

Insert into #depara Select 1, 'NFSe', 'TCNFSe', '' 
--Insert into #depara Select 1, 'evento', 'TCEvento', '' 

Set @Sql = '
Select Identity(int,1,1) NUM, value
into ##tabelement
	From string_split(
	(SELECT *
	FROM OPENROWSET(BULK ''' + @xsd + ''' , SINGLE_CLOB) AS FileContent), char(13)
	)'
EXEC (@SQL);


SET @SQL = '
SELECT IDENTITY(int,1,1) AS NUM,
       SUBSTRING(value, 22, CHARINDEX(''">'', value) - 22) AS Tabelas
INTO ##complextype
FROM string_split(
        (SELECT * FROM OPENROWSET(BULK ''' + @xsd + ''', SINGLE_CLOB) AS FileContent),
        ''<''
     )
WHERE value LIKE ''xs:complexType name="%'''


EXEC (@SQL);

--select * from #complextype where Tabelas like '%valores%'

Declare
@i int = 1,
@s varchar(200),
@j int,
@k int
While @i <=(Select max(Num) From ##complextype)
Begin
	IF OBJECT_ID('tempdb..#tabxtab') IS NOT NULL DROP TABLE #tabxtab

	Select @s = Tabelas
	From ##complextype
	Where Num = @i
	--and Tabelas like '%valores%'
	select @j = num
	from ##tabelement
	Where value like '%<xs:complexType name="' + @s + '">'
	select top 1 @k = num
	from ##tabelement
	Where value like '%</xs:complexType>%'
	and num > @j

	While @j <= @k
	Begin
		insert into #depara
		Select	num,
						Substring(value, charindex('name="', value) + 6, Charindex('" type="', value) - (charindex('name="', value) + 6) ) as DE,
						Substring(value, charindex('" type="', value) + 8, Charindex('"', value, charindex('" type="', value) + 8) - (charindex('" type="', value) + 8) ) as PARA,
						@s
		From ##tabelement
		where num = @j
		and ((value like '%xs:element%' and value like '%type="TC%') 
				--or (value like '%xs:attribute%' and value like '%type="TV%')
				)

		set @j = @j + 1		
	End

	Set @i = @i + 1
End


--Select * From #depara order by de
--Select * From #depara where para = 'TCInfoPessoa'
--Select para, pai, count(1) From #depara group by para, pai

Select a.DE, a.PARA, a.Pai, '' + (IsNull(j.de + '/','') + IsNull(i.de + '/','') + IsNull(h.de + '/','') + IsNull(g.de + '/','') + IsNull(f.de + '/','') + IsNull(e.de + '/','') + IsNull(d.de + '/','') + IsNull(c.de + '/','') + IsNull(b.de + '/','')  + a.de) as CAMINHO
--Select a.DE, a.PARA, a.Pai, '' + (IsNull(b.de + '/','')  + a.de) as CAMINHO
Into #deparaCam
From #depara a
LEFT JOIN #depara b on b.PARA = a.PAI
LEFT JOIN #depara c on c.PARA = b.PAI
LEFT JOIN #depara d on d.PARA = c.PAI
LEFT JOIN #depara e on e.PARA = d.PAI
LEFT JOIN #depara f on f.PARA = e.PAI
LEFT JOIN #depara g on g.PARA = f.PAI
LEFT JOIN #depara h on h.PARA = g.PAI
LEFT JOIN #depara i on i.PARA = h.PAI
LEFT JOIN #depara j on j.PARA = i.PAI



IF OBJECT_ID('tempdb..##temp') IS NOT NULL DROP TABLE ##temp
IF OBJECT_ID('tempdb..#result') IS NOT NULL DROP TABLE #result
IF OBJECT_ID('tempdb..#modelo') IS NOT NULL DROP TABLE #modelo
IF OBJECT_ID('tempdb..#val') IS NOT NULL DROP TABLE #val

Set @sql = '
SELECT identity(int,1,1) as Num, * 
Into ##temp
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
  ''Excel 12.0 Xml;Database=' + @xls + ';'', '+ @xls_plan +')
Where Campo is not null
'
Exec(@sql)

--ALter Table ##temp Add F10 varchar(2000)

--Fazer o de para com as novas tabelas
declare
@i_troca int = 1,
@j_para int = 8,
@de varchar(200),
@para varchar(200)

--select * from ##temp

While @i_troca <= (Select max(num) From ##temp)
Begin
	
	If(Select ELE From ##temp Where Num = @i_troca) in ('G', 'CG', 'Raiz')
	Begin
		--Select 'antes',* From #temp Where Num = @i_troca

		--Select @de, @para, *
		--From #temp	
		--INNER JOIN #depara on #depara.DE = #temp.CAMPO 
		--Where Num = @i_troca
		--
		--Select CAMPO, de, Para , [CAMINHO NO XML]+Campo, CAMINHO--@de, @para, *
		Update a
		Set a.F10 = b.Para
		----Set a.CAMPO = b.Para
		From ##temp a
		INNER JOIN #deparacam b on b.DE = a.CAMPO 
		Where Num = @i_troca
		and [CAMINHO NO XML]+Campo = CAMINHO
		
	End
	set @i_troca = @i_troca + 1
End

--select * from ##temp where ELE in ('G', 'CG', 'Raiz')
--Select * from #deparaCam
--evento/infEvento
--evento/infEvento/pedRegEvento

--NFSe/NFSe
--NFSe/NFSe/infNFSe
--NFSe/infNFSe
--Fim

Create Table #result (Num int identity(1,1), resultBanco varchar(max), resultMermaid varchar(max), tabela varchar(200), nivel int)
Create Table #modelo (Num int identity(1,1), resultado varchar(max))

declare 
@create varchar(max) = ''

exec #CriarTabelas 1, 446, '', '', '', @create	,'', '', '','', 0, ''

--select resultBanco, resultMermaid From #result order by nivel desc
select resultBanco From #result order by nivel desc

--select resultBanco From #result order by tabela

--select 'IF OBJECT_ID(''' + tabela + ''') IS NOT NULL Drop Table ' + Tabela from #result Where Substring(Tabela, 1,2) = 'TC' order by nivel 

Select resultado into #val from #modelo group by resultado having count(1) > 1
delete 
from #modelo
where resultado in (select resultado from #val)
insert into #modelo select * from #val

--select distinct * from #modelo

/*
--IF OBJECT_ID('tempdb..#teste') IS NOT NULL DROP TABLE #teste

Select *
From (
	Select campo as cam, count(1)as qde
	--into #teste
	From #temp
	Where ele in ('g', 'cg')
	Group by campo
	Having count(1) > 1) as a
inner join #temp b on b.campo = a.cam

*/

