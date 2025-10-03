
------------------------------------------------------------------------------------------------------------------------
--AUTOR					: FERNANDO KINKEL SEREJO
--DATA					: 19/09/2025
--DEPARTAMENTO			: SEF
--SERVIDOR SQL			: LOCAL
--ASSUNTO				: Montar tabelas conforme o Leioute (AnexoVI-LeiautesRN_RTC_IBSCBS-V1.01.01FigSchema.xlsx)
------------------------------------------------------------------------------------------------------------------------
/*
IF OBJECT_ID('tempdb..#NOTASPERIODO') IS NOT NULL DROP PROCEDURE #NOTASPERIODO

create procedure #NOTASPERIODO(@INI as int, @FIN as int, @tab as varchar(100), @cam as varchar(255))
as
begin
  Declare
  @nCam varchar(max)
  Select @nCam = [Caminho no XML]
  From #temp
  Where Num = @ini

  Select @ini as Inicio, @fin as Final, @tab as Tabela, @cam as Campo,
  Case TIPO 
	When 'C' Then 'varchar('+TAM#+')' 
	When 'CE' Then 'varchar('+TAM#+')' 
	When 'N' Then 'Int'
  End as Tipo, *
  From #temp
  Where Num = @ini

  set @ini = @ini +1
  if @ini <= @fin
	exec #NOTASPERIODO @ini, @fin, 'TCInfNfse', 'xLocEmi'
end

*/


IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

SELECT identity(int,1,1) as Num, * 
Into #temp
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
  'Excel 12.0 Xml;Database=C:\Temp\RN_RTC_IBSCBS_V1_01_01.xlsx;', Leiaute_DPS_NFS$)
Where Campo is not null

exec #NOTASPERIODO 4, 200, 'TCInfNfse', 'xLocEmi'

/*
--select [CAMINHO NO XML], CAMPO, ELE, TIPO, OCOR#, TAM# from #temp

declare
@i int = 1,
@j int,
@k int = 0,
@tab int = 0,
@cam int = 0


Select @j = max(Num) From #temp 
While @i <= @j 
Begin
	if(select ELE From #temp Where Num = @i) in ('G', 'CG', 'RAIZ') 
	begin
		Select 'Tabela', * From #temp Where Num =  @i
	end
	else
	begin
		Select 'Campo', * From #temp Where Num =  @i
	end


	Set @i = @i + 1
End
*/
