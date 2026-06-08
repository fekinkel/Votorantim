------------------------------------------------------------------------------------------------------------------------
--AUTOR					: FERNANDO KINKEL SEREJO
--DATA					: 30/06/2026
--DEPARTAMENTO	: SEF
--SERVIDOR SQL	: LOCAL
--ASSUNTO				: DANFSe
------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

SELECT identity(int,1,1) as Num, * 
Into #temp
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
  'Excel 12.0 Xml;Database=C:\Temp\NT_008_DANFSe_1.xlsx;', Planilha1$)
Where bloco is not null
and  bloco <> 99

--Select * From #temp

/*
--Calcular de cm para pixel
Select F1, F2, F3, F4, 
Round([Alt#] * 96 / 2.54, 2) as ALT,
Round([Larg#] * 96 / 2.54, 2) as LAR,
Round([Esq#] * 96 / 2.54, 2) as ESQ,
Round([Sup#] * 96 / 2.54, 2) as SUP,*
From #temp
*/

declare
@i int ,
@j int ,
@bloco int = 1,
@largura decimal(20,2) = 20.4,
@altFonte int,
@topBase decimal(20,2),
@aux decimal(20,2),
@heiBloco varchar(20),
@widBloco varchar(20),
@p varchar(50),
@hei varchar(20),
@wid varchar(20),
@lef varchar(20),
@top varchar(20),
@texto varchar(8000),
@campo varchar(8000),
@nome varchar(8000),
@linha varchar(8000)

IF OBJECT_ID('tempdb..#geral') IS NOT NULL DROP TABLE #geral

Select identity(int,1,1) as Num, REPLICATE('x', 8000) as linha, 10 as bloco into #geral from #temp where 1 = 0
Select * From #temp
Select * From #geral

While @bloco <= (Select Max(bloco) From #temp)
Begin
		if(@bloco = 1)
		Begin			
			--Obter Bloco
			Select @i = Min(num)  From #temp Where bloco = @bloco
			--Obter Altura do bloco 
			Select @heiBloco = Convert(varchar(20),Round((Max(F10) * 96 / 2.54), 2) ), @widBloco = Convert(varchar(20), Round(Convert(decimal(20,2),(@largura * 96 / 2.54)), 2)  )  From #temp Where bloco = @bloco

			Select top 1 @linha = '<PageHeaderBand Name="PageHeaderBand' + Convert(Varchar(6), bloco) + '" Width="'+ @widBloco+'" Height="' + @heiBloco+ '" Border.Lines="All">'			
			From #temp Where bloco = @bloco

			Insert into #geral
			Select @linha, @bloco
			While @i <= (Select Max(Num) From #temp Where bloco = @bloco)
			Begin
				Select @campo = campo,
					@nome = nome,
					@texto = Texto,
					@hei = Convert(Varchar(20),Round([Alt#]  * 96 / 2.54, 2)), 
					@wid = Convert(varchar(20),Round([Larg#] * 96 / 2.54, 2)), 
					@lef = Convert(varchar(20),Round([Esq#]  * 96 / 2.54, 2)), 
					@top = Convert(Varchar(20),Round([Sup#]  * 96 / 2.54, 2)) 
				From #temp Where bloco = @bloco and Num = @i
				if(@campo like 'sh%')
				Begin
					Select @linha = '<ShapeObject Name="Shape_' + dbo.InitCap(campo) +'" Left="'+ @lef +'" Top="'+ @top +'" Width="' + @wid + '" Height="'+ @hei +'" Border.Width="0.5" Fill.Color="242, 242, 242"/>'
					From #temp Where bloco = @bloco and Num = @i
				End
				Else Begin
					Select @linha = '<TextObject Name="txt_' + dbo.InitCap(campo) +'" Width="771.12" Height="40" Border.Width="0.5" Fill.Color="242, 242, 242"/>'
					From #temp Where bloco = @bloco and Num = @i
				End
				Insert into #geral
				Select @linha, @bloco

				Set @i = @i + 1
			End
			 
			Select top 1 @linha = '</PageHeaderBand>'					

			Insert into #geral
			Select @linha, @bloco

		End Else if(@bloco = (Select Max(bloco) From #temp) )
		Begin
			Select top 1 @linha = '<PageFooterBand Name="PageFooterBand' + Convert(Varchar(6), bloco) + '" Width="793.8" Height="43.85" Border.Lines="All">'
			From #temp Where bloco = @bloco
			Insert into #geral
			Select @linha, @bloco

			Select top 1 @linha = '</PageFooterBand>'					

			Insert into #geral
			Select @linha, @bloco

		End Else
		Begin
				--Obter Bloco
			Select @i = Min(num), @topBase = Min([Sup#])  From #temp Where bloco = @bloco
			--Obter Altura do bloco 
			Select @heiBloco = Convert(varchar(20),Round((Max(F10) * 96 / 2.54), 2) ), @widBloco = Convert(varchar(20), Round(Convert(decimal(20,2),(@largura * 96 / 2.54)), 2)  )  From #temp Where bloco = @bloco

			Select top 1 @linha = '<DataBand Name="DataBand_' + Convert(Varchar(6), bloco) + '" Width="' +@widBloco+ '" Height="'+@heiBloco+'" DataSource="dsRelatorio">'
			From #temp Where bloco = @bloco
			Insert into #geral
			Select @linha, @bloco

			While @i <= (Select Max(Num) From #temp Where bloco = @bloco)
			Begin
			--Exemplos
			/*
				<ShapeObject Name="Shape3" Left="11.34" Width="771.12" Height="97.15"/>
				<TextObject Name="Text1" Left="11.34" Width="192.4" Height="23.81" Text="PRESTADOR / FORNECEDOR " Padding="0, 0, 0, 0" Font="Arial, 7pt, style=Bold"/>
				<TextObject Name="Text2" Left="204.5" Width="192.4" Height="9.34" Text=" CNPJ / CPF / NIF" Padding="0, 0, 0, 0" Font="Arial, 6pt, style=Bold"/>
				<TextObject Name="Text3" Left="204.5" Top="14.48" Width="192.4" Height="9.34" Text="22.911.618/0001-46" Padding="0, 0, 0, 0" Font="Microsoft Sans Serif, 6.75pt"/>
			*/
				Select @campo = campo, 
					@nome =  nome,
					@texto = Texto,
					@hei = Convert(Varchar(20),Round([Alt#]  * 96 / 2.54, 2)), 
					@wid = Convert(varchar(20),Round([Larg#] * 96 / 2.54, 2)), 
					@lef = Convert(varchar(20),Round([Esq#]  * 96 / 2.54, 2)), 
					@top = Convert(Varchar(20),Round(([Sup#]-@topBase)  * 96 / 2.54, 2)) 
				From #temp Where bloco = @bloco and Num = @i
print '1 LBL Bloco: '	+ @campo
				if(@campo = '' or @campo is null)
				Begin
print '2 LBL Bloco: '--+ convert(varchar(10),@bloco)-- + ' - Top Base :'+ convert(varchar(10),@topBase)
					---Criar o label
					Select @linha = '<TextObject Name="lbl_' + Convert(varchar(10),@i) +'" Left="'+ @lef +'" Top="'+ @top +'" Width="' + @wid + '" Height="'+ @hei +'" Text="' + Rtrim(Ltrim(@texto)) + '" Padding="0, 2, 0, 0" Font="Arial, 7pt, style=Bold"/>'
					From #temp Where bloco = @bloco and Num = @i
					Print 'Campo Vazio'
					print 'Valor é: ' + @linha
					
					Insert into #geral
					Select @linha, @bloco

				End Else if (@campo <> 'sh') Begin

					if(@bloco = 2)
					Begin
						set @altFonte = 7
					End Else Begin
						set @altFonte = 6
					End

					Select @aux = ((@altFonte+.999) * 0.03527 )
					Select @campo = campo, 
						@nome = nome,
						@texto = Texto,
						@hei = CAST(CAST(Round((@aux * 96 / 2.54), 2) AS DECIMAL(18,2)) AS VARCHAR(20)), 
						@wid = Convert(varchar(20),Round([Larg#] * 96 / 2.54, 2)), 
						@lef = Convert(varchar(20),Round([Esq#]  * 96 / 2.54, 2)), 
						@top = Convert(Varchar(20),Round(([Sup#]-@topBase)  * 96 / 2.54, 2)) 
					From #temp Where bloco = @bloco and Num = @i
print 'LBL Bloco: '+ convert(varchar(10),@bloco) + ' - Top Base :'+ convert(varchar(10),@topBase)
print 'LBL Bloco: '+ convert(varchar(10),@bloco) + ' - Heigth :'+ convert(varchar(10),@hei)
print 'LBL Bloco: '+ convert(varchar(10),@bloco) + ' - Top :'+ convert(varchar(10),@top)
					--Print 'Campo ' + @Campo
					---Criar o label
					--<TextObject Name="Text2" Left="204.5" Width="192.4" Height="9.34" Text=" CNPJ / CPF / NIF" Padding="0, 0, 0, 0" Font="Arial, 6pt, style=Bold"/>
					if(@bloco = 2)
					Begin
						Select	@linha = '<TextObject Name="lbl_' + nome +'" Left="'+ @lef +'" Top="'+ @top +'" Width="' + @wid + '" Height="'+ @hei +'" Text="' + upper(@texto) + '" Padding="0, 2, 0, 0" Font="Arial, '+Convert(varchar(1),@altFonte)+'pt, style=Bold"/>'
						From #temp Where bloco = @bloco and Num = @i
					End Else Begin
						Select	@linha = '<TextObject Name="lbl_' + nome +'" Left="'+ @lef +'" Top="'+ @top +'" Width="' + @wid + '" Height="'+ @hei +'" Text="' + dbo.fn_PrimeiraLetraMaiuscula(@texto) + '" Padding="0, 2, 0, 0" Font="Arial, '+Convert(varchar(1),@altFonte)+'pt, style=Bold"/>'
						From #temp Where bloco = @bloco and Num = @i
					End
					

					Insert into #geral
					Select @linha, @bloco
					Select @campo = campo, 
						@nome = nome,
						@hei = CAST(CAST(Round((((@altFonte+1.4) * 0.03527 ) * 96 / 2.54), 2) AS DECIMAL(18,2)) AS VARCHAR(20)), 
						@wid = Convert(varchar(20),Round([Larg#] * 96 / 2.54, 2)), 
						@lef = Convert(varchar(20),Round([Esq#]  * 96 / 2.54, 2)), 
						--@top = Convert(Varchar(20),Round((([Sup#]-@topBase)+([Alt#]-((@altFonte+.999) * 0.03527 )))  * 96 / 2.54, 2)) 
						@top = Convert(Varchar(20),Round((([Sup#]-@topBase)+(@aux))  * 96 / 2.54, 2)) 
					From #temp Where bloco = @bloco and Num = @i
print 'Bloco: '+ convert(varchar(10),@bloco) + ' - Top Base :'+ convert(varchar(10),@topBase)
print 'Bloco: '+ convert(varchar(10),@bloco) + ' - Heigth :'+ convert(varchar(10),@hei)
print 'Bloco: '+ convert(varchar(10),@bloco) + ' - Top :'+ convert(varchar(10),@top)

					--Criar o Text
					--<TextObject Name="Text3" Left="204.5" Top="14.48" Width="192.4" Height="9.34" Text="22.911.618/0001-46" Padding="0, 0, 0, 0" Font="Microsoft Sans Serif, 6.75pt"/>			
					Select @linha = '<TextObject Name="txt_' + nome +'" Left="'+ @lef +'" Top="'+ @top +'" Width="' + @wid + '" Height="'+ @hei +'" Text="[dsRelatorio.' + @nome + ']" Padding="0, 2, 0, 0" Font="Microsoft Sans Serif, 7pt"/>'
					From #temp Where bloco = @bloco and Num = @i
					
					Insert into #geral
					Select @linha, @bloco
				End

				Set @i = @i + 1
			End 
			Select top 1 @linha = '</DataBand>'					

			Insert into #geral
			Select @linha, @bloco

		End

	Select @p = Case bloco
		When 1 Then 'PageHeaderBand'
		When 13 Then 'PageFooterBand'
		Else 'DataBand'
		End
	From #temp Where bloco = @bloco
	 
	Select '<' + @p +' Name="'+ @p + Convert(Varchar(6), bloco) + '" Width="793.8" Height="43.85" Border.Lines="All">'
	From #temp Where bloco = @bloco
	Group By Bloco
	--<DataBand Name="Data1" Top="47.85" Width="793.8" Height="107.35" Border.Lines="All" DataSource="dsRelatorio">
	set @bloco = @bloco + 1
End
Select * 
From #geral
Where linha is Not Null

Select bloco, Max([Larg#])
from #temp
Group by bloco
USE [CNPJ]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_PrimeiraLetraMaiuscula]    Script Date: 08/06/2026 08:02:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_PrimeiraLetraMaiuscula] (@Texto VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    -- Se o texto for nulo ou vazio, retorna ele mesmo
    IF @Texto IS NULL OR @Texto = '' RETURN @Texto;

    DECLARE @Resultado VARCHAR(MAX) = '';
		DECLARE @textoNew VARCHAR(MAX) ;
		Select @textoNew = Ltrim(Rtrim(@texto))
    -- Divide o texto por espaços (O nível de compatibilidade do banco deve ser >= 130)
    SELECT @Resultado = @Resultado + 
        CASE 
            -- Palavras com 3 ou menos caracteres ficam totalmente em minúsculo
            WHEN LEN(value) <= 3 THEN LOWER(value)
            -- Palavras maiores que 3 ganham a primeira letra maiúscula
            ELSE UPPER(LEFT(value, 1)) + LOWER(SUBSTRING(value, 2, LEN(value)))
        END + ' '
    FROM STRING_SPLIT(@textoNew, ' ');

    -- Remove o último espaço extra gerado no loop e retorna
    RETURN RTRIM(@Resultado);
END;
