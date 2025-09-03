using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace ConsultaApiA3.NFSE
{
	// using System.Xml.Serialization;
	// XmlSerializer serializer = new XmlSerializer(typeof(NFSe));
	// using (StringReader reader = new StringReader(xml))
	// {
	//    var test = (NFSe)serializer.Deserialize(reader);
	// }

	[XmlRoot(ElementName = "enderNac")]
	public class EnderNac
	{

		[XmlElement(ElementName = "xLgr")]
		public string XLgr { get; set; }

		[XmlElement(ElementName = "nro")]
		public int Nro { get; set; }

		[XmlElement(ElementName = "xCpl")]
		public string XCpl { get; set; }

		[XmlElement(ElementName = "xBairro")]
		public string XBairro { get; set; }

		[XmlElement(ElementName = "cMun")]
		public int CMun { get; set; }

		[XmlElement(ElementName = "UF")]
		public string UF { get; set; }

		[XmlElement(ElementName = "CEP")]
		public int CEP { get; set; }		
	}

	[XmlRoot(ElementName = "emit")]
	public class Emit
	{
		[Key]
		[XmlElement(ElementName = "CNPJ")]
		public string CNPJ { get; set; }

		[XmlElement(ElementName = "CPF")]
		public string CPF { get; set; }

		[XmlElement(ElementName = "IM")]
		public string IM { get; set; }

		[XmlElement(ElementName = "xNome")]
		public string XNome { get; set; }

		[XmlElement(ElementName = "xFant")]
		public string xFant { get; set; }

		//[XmlElement(ElementName = "enderNac")]
		//public EnderNac EnderNac { get; set; }

		[XmlElement(ElementName = "fone")]
		public string Fone { get; set; }
	}

	[XmlRoot(ElementName = "valores")]
	public class Valores
	{
		[Key]
		public int ID { get; set; }
		[XmlElement(ElementName = "vCalcDR")]
		public double vCalcDR { get; set; }

		[XmlElement(ElementName = "tpBM")]
		public int tpBM { get; set; }

		[XmlElement(ElementName = "vCalcBM")]
		public double vCalcBM { get; set; }

		[XmlElement(ElementName = "vBC")]
		public double vBC { get; set; }

		[XmlElement(ElementName = "vTotalRet")]
		public double VTotalRet { get; set; }

		[XmlElement(ElementName = "vLiq")]
		public double VLiq { get; set; }
		
		//[XmlElement(ElementName = "vServPrest")]
		//public VServPrest VServPrest { get; set; }
		//[XmlElement(ElementName = "trib")]
		//public Trib Trib { get; set; }
	}

	[XmlRoot(ElementName = "regTrib")]
	public class RegTrib
	{

		[XmlElement(ElementName = "opSimpNac")]
		public int OpSimpNac { get; set; }

		[XmlElement(ElementName = "regEspTrib")]
		public int RegEspTrib { get; set; }
	}

	[XmlRoot(ElementName = "prest")]
	public class Prest
	{

		[XmlElement(ElementName = "CNPJ")]
		public double CNPJ { get; set; }

		[XmlElement(ElementName = "fone")]
		public double Fone { get; set; }

		[XmlElement(ElementName = "email")]
		public string Email { get; set; }

		[XmlElement(ElementName = "regTrib")]
		public RegTrib RegTrib { get; set; }
	}

	[XmlRoot(ElementName = "interm")]
	public class Interm
	{

		[XmlElement(ElementName = "CNPJ")]
		public double CNPJ { get; set; }

		[XmlElement(ElementName = "xNome")]
		public string XNome { get; set; }
	}

	[XmlRoot(ElementName = "locPrest")]
	public class LocPrest
	{

		[XmlElement(ElementName = "cLocPrestacao")]
		public int CLocPrestacao { get; set; }
	}

	[XmlRoot(ElementName = "cServ")]
	public class CServ
	{

		[XmlElement(ElementName = "cTribNac")]
		public int CTribNac { get; set; }

		[XmlElement(ElementName = "xDescServ")]
		public string XDescServ { get; set; }
	}

	[XmlRoot(ElementName = "serv")]
	public class Serv
	{

		[XmlElement(ElementName = "locPrest")]
		public LocPrest LocPrest { get; set; }

		[XmlElement(ElementName = "cServ")]
		public CServ CServ { get; set; }
	}

	[XmlRoot(ElementName = "vServPrest")]
	public class VServPrest
	{

		[XmlElement(ElementName = "vServ")]
		public double VServ { get; set; }
	}

	[XmlRoot(ElementName = "tribMun")]
	public class TribMun
	{

		[XmlElement(ElementName = "tribISSQN")]
		public int TribISSQN { get; set; }

		[XmlElement(ElementName = "tpRetISSQN")]
		public int TpRetISSQN { get; set; }
	}

	[XmlRoot(ElementName = "totTrib")]
	public class TotTrib
	{

		[XmlElement(ElementName = "indTotTrib")]
		public int IndTotTrib { get; set; }
	}

	[XmlRoot(ElementName = "trib")]
	public class Trib
	{

		[XmlElement(ElementName = "tribMun")]
		public TribMun TribMun { get; set; }

		[XmlElement(ElementName = "totTrib")]
		public TotTrib TotTrib { get; set; }
	}

	[XmlRoot(ElementName = "infDPS")]
	public class InfDPS
	{

		[XmlElement(ElementName = "tpAmb")]
		public int TpAmb { get; set; }

		[XmlElement(ElementName = "dhEmi")]
		public DateTime DhEmi { get; set; }

		[XmlElement(ElementName = "verAplic")]
		public string VerAplic { get; set; }

		[XmlElement(ElementName = "serie")]
		public int Serie { get; set; }

		[XmlElement(ElementName = "nDPS")]
		public int NDPS { get; set; }

		[XmlElement(ElementName = "dCompet")]
		public DateTime DCompet { get; set; }

		[XmlElement(ElementName = "tpEmit")]
		public int TpEmit { get; set; }

		[XmlElement(ElementName = "cLocEmi")]
		public int CLocEmi { get; set; }

		[XmlElement(ElementName = "prest")]
		public Prest Prest { get; set; }

		[XmlElement(ElementName = "interm")]
		public Interm Interm { get; set; }

		[XmlElement(ElementName = "serv")]
		public Serv Serv { get; set; }

		[XmlElement(ElementName = "valores")]
		public Valores Valores { get; set; }

		[XmlAttribute(AttributeName = "Id")]
		public string Id { get; set; }

		[XmlText]
		public string Text { get; set; }
	}

	[XmlRoot(ElementName = "DPS")]
	public class DPS
	{

		[XmlElement(ElementName = "infDPS")]
		public InfDPS InfDPS { get; set; }

		[XmlAttribute(AttributeName = "versao")]
		public double Versao { get; set; }

		[XmlAttribute(AttributeName = "xmlns")]
		public string Xmlns { get; set; }

		[XmlText]
		public string Text { get; set; }
	}

	[XmlRoot(ElementName = "infNFSe")]
	public class InfNFSe
	{

		[XmlElement(ElementName = "xLocEmi")]
		public string XLocEmi { get; set; }

		[XmlElement(ElementName = "xLocPrestacao")]
		public string XLocPrestacao { get; set; }

		[XmlElement(ElementName = "nNFSe")]
		public int NNFSe { get; set; }

		[XmlElement(ElementName = "cLocIncid")]
		public int CLocIncid { get; set; }

		[XmlElement(ElementName = "xLocIncid")]
		public string XLocIncid { get; set; }

		[XmlElement(ElementName = "xTribNac")]
		public string XTribNac { get; set; }

		[XmlElement(ElementName = "verAplic")]
		public string VerAplic { get; set; }

		[XmlElement(ElementName = "ambGer")]
		public int AmbGer { get; set; }

		[XmlElement(ElementName = "tpEmis")]
		public int TpEmis { get; set; }

		[XmlElement(ElementName = "procEmi")]
		public int ProcEmi { get; set; }

		[XmlElement(ElementName = "cStat")]
		public int CStat { get; set; }

		[XmlElement(ElementName = "dhProc")]
		public DateTime DhProc { get; set; }

		[XmlElement(ElementName = "nDFSe")]
		public int NDFSe { get; set; }

		[XmlElement(ElementName = "emit")]
		public Emit Emit { get; set; }

		[XmlElement(ElementName = "valores")]
		public Valores Valores { get; set; }

		[XmlElement(ElementName = "DPS")]
		public DPS DPS { get; set; }

		[XmlAttribute(AttributeName = "Id")]
		public string Id { get; set; }

		[XmlText]
		public string Text { get; set; }
	}

	[XmlRoot(ElementName = "CanonicalizationMethod")]
	public class CanonicalizationMethod
	{

		[XmlAttribute(AttributeName = "Algorithm")]
		public string Algorithm { get; set; }
	}

	[XmlRoot(ElementName = "SignatureMethod")]
	public class SignatureMethod
	{

		[XmlAttribute(AttributeName = "Algorithm")]
		public string Algorithm { get; set; }
	}

	[XmlRoot(ElementName = "Transform")]
	public class Transform
	{

		[XmlAttribute(AttributeName = "Algorithm")]
		public string Algorithm { get; set; }
	}

	[XmlRoot(ElementName = "Transforms")]
	public class Transforms
	{

		[XmlElement(ElementName = "Transform")]
		public List<Transform> Transform { get; set; }
	}

	[XmlRoot(ElementName = "DigestMethod")]
	public class DigestMethod
	{

		[XmlAttribute(AttributeName = "Algorithm")]
		public string Algorithm { get; set; }
	}

	[XmlRoot(ElementName = "Reference")]
	public class Reference
	{

		[XmlElement(ElementName = "Transforms")]
		public Transforms Transforms { get; set; }

		[XmlElement(ElementName = "DigestMethod")]
		public DigestMethod DigestMethod { get; set; }

		[XmlElement(ElementName = "DigestValue")]
		public string DigestValue { get; set; }

		[XmlAttribute(AttributeName = "URI")]
		public string URI { get; set; }

		[XmlText]
		public string Text { get; set; }
	}

	[XmlRoot(ElementName = "SignedInfo")]
	public class SignedInfo
	{

		[XmlElement(ElementName = "CanonicalizationMethod")]
		public CanonicalizationMethod CanonicalizationMethod { get; set; }

		[XmlElement(ElementName = "SignatureMethod")]
		public SignatureMethod SignatureMethod { get; set; }

		[XmlElement(ElementName = "Reference")]
		public Reference Reference { get; set; }
	}

	[XmlRoot(ElementName = "X509Data")]
	public class X509Data
	{

		[XmlElement(ElementName = "X509Certificate")]
		public string X509Certificate { get; set; }
	}

	[XmlRoot(ElementName = "KeyInfo")]
	public class KeyInfo
	{

		[XmlElement(ElementName = "X509Data")]
		public X509Data X509Data { get; set; }
	}

	[XmlRoot(ElementName = "Signature")]
	public class Signature
	{

		[XmlElement(ElementName = "SignedInfo")]
		public SignedInfo SignedInfo { get; set; }

		[XmlElement(ElementName = "SignatureValue")]
		public string SignatureValue { get; set; }

		[XmlElement(ElementName = "KeyInfo")]
		public KeyInfo KeyInfo { get; set; }

		[XmlAttribute(AttributeName = "xmlns")]
		public string Xmlns { get; set; }

		[XmlText]
		public string Text { get; set; }
	}

	[XmlRoot(ElementName = "NFSe")]
	public class NFSe
	{

		[XmlElement(ElementName = "infNFSe")]
		public InfNFSe InfNFSe { get; set; }

		[XmlElement(ElementName = "Signature")]
		public Signature Signature { get; set; }

		[XmlAttribute(AttributeName = "versao")]
		public double Versao { get; set; }

		[XmlAttribute(AttributeName = "xmlns")]
		public string Xmlns { get; set; }

		[XmlText]
		public string Text { get; set; }
	}


}
