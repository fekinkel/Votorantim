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
@p varchar(50)

IF OBJECT_ID('tempdb..#geral') IS NOT NULL DROP TABLE #geral

While @bloco <= (Select Max(bloco) From #temp)
Begin
		if(@bloco = 1)
		Begin
				print 1
		End Else if(@bloco = (Select Max(bloco) From #temp) )
		Begin
					 print 2
		End Else
		Begin
				 print 3
		End

	Select @p = Case bloco
		When 1 Then 'PageHeaderBand'
		When 13 Then 'PageFooterBand'
		Else 'DataBand'
		End
	From #temp Where bloco = @bloco
	       <ShapeObject Name="Shape3" Left="11.34" Width="771.12" Height="97.15"/>
      <TextObject Name="Text1" Left="11.34" Width="192.4" Height="23.81" Text="PRESTADOR / FORNECEDOR " Padding="0, 0, 0, 0" Font="Arial, 7pt, style=Bold"/>
      <TextObject Name="Text2" Left="204.5" Width="192.4" Height="9.34" Text=" CNPJ / CPF / NIF" Padding="0, 0, 0, 0" Font="Arial, 6pt, style=Bold"/>
      <TextObject Name="Text3" Left="204.5" Top="14.48" Width="192.4" Height="9.34" Text="22.911.618/0001-46" Padding="0, 0, 0, 0" Font="Microsoft Sans Serif, 6.75pt"/>

	Select '<' + @p +' Name="'+ @p + Convert(Varchar(6), bloco) + '" Width="793.8" Height="43.85" Border.Lines="All">'
	From #temp Where bloco = @bloco
	Group By Bloco
	--<DataBand Name="Data1" Top="47.85" Width="793.8" Height="107.35" Border.Lines="All" DataSource="dsRelatorio">
	set @bloco = @bloco + 1
End

Select bloco, Max([Larg#])
from #temp
Group by bloco
