using PMV.Tributario.DL.Nfse.DS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PMV.Tributario.DL.Nfse.NFSE
{
    public class CodigoIBGE : BaseNFSE<NS_CODIGO_IBGE, int>
    {
        #region

        #endregion

        #region Construtor
        public CodigoIBGE() : base()
        {
        }
        #endregion

        #region Metodos
        private void gerarEntity()
        {
            //provider connection string=&quot;data source=PMVOTORSRVSEF;initial catalog=CNPJ;persist security info=True;user id=sa;password=pmvsef327;MultipleActiveResultSets=True;App=EntityFramework&quot;" providerName="System.Data.EntityClient
            _Entity = new NFSEEntities(@"metadata=res://*/DS.DSNfse.csdl|res://*/DS.DSNfse.ssdl|res://*/DS.DSNfse.msl;
                                        provider=System.Data.SqlClient;
                                        provider connection string='data source=pmvotorsrvsef;initial catalog=NFSE;user id=sa;password=pmvsef327;MultipleActiveResultSets=True;App=EntityFramework'");
        }
        public override NS_CODIGO_IBGE Buscar(int key)
        {
            throw new NotImplementedException();
        }

        public override void Excluir(int key)
        {
            throw new NotImplementedException();
        }

        public override void Gravar(NS_CODIGO_IBGE item)
        {
            throw new NotImplementedException();
        }

        public override List<NS_CODIGO_IBGE> Listar()
        {
            try
            {
                gerarEntity();
                var lista = _Entity.NS_CODIGO_IBGE.ToList();

                return lista;
            }
            catch (Exception ex)
            {
                throw new Biblioteca.Exceptions.FalhaAcesso("Não foi possível acessar a tabela de feira.", ex);
            }
        }

        #endregion
    }
}
