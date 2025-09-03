
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsultaApiA3.NFSE
{
    public class GerarTabelasXML : DbContext
    {
        public GerarTabelasXML() : base("MinhaConexao") { }

        public DbSet<Emit> Emits { get; set; }
        //public DbSet<EnderNac> Enderecos { get; set; }
        public DbSet<Valores> Valores { get; set; }
        //public DbSet<RegTrib> RegTrib { get; set; }
        //public DbSet<Prest> Prest { get; set; }
        //public DbSet<Interm> Interm { get; set; }
        //public DbSet<LocPrest> LocPrest { get; set; }
        //public DbSet<CServ> CServ { get; set; }
        //public DbSet<Serv> Serv { get; set; }
        //public DbSet<VServPrest> VServPrest { get; set; }
        //public DbSet<TribMun> TribMun { get; set; }
        //public DbSet<TotTrib> TotTrib { get; set; }
        //public DbSet<Trib> Trib { get; set; }
        //public DbSet<InfDPS> InfDPS { get; set; }
        //public DbSet<DPS> DPS { get; set; }
        //public DbSet<InfNFSe> InfNFSe { get; set; }
        //public DbSet<CanonicalizationMethod> CanonicalizationMethod { get; set; }
        //public DbSet<SignatureMethod> SignatureMethod { get; set; }
        //public DbSet<NFSe> NFSe { get; set; }
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // Configuração opcional de relacionamento 1:1
            //
            base.OnModelCreating(modelBuilder);
        }

    }
}
