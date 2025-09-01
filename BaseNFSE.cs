using PMV.Tributario.DL.Nfse.DS;
using System.Collections.Generic;

namespace PMV.Tributario.DL.Nfse.NFSE
{
    public abstract class BaseNFSE<T, Z>
    {
        protected NFSEEntities _Entity;

        public BaseNFSE()
        {
            _Entity = new NFSEEntities();
        }
        public abstract T Buscar(Z key);
        public abstract List<T> Listar();
        public abstract void Gravar(T item);
        public abstract void Excluir(Z key);    


    }
}
