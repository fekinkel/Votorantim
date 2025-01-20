using SevenZip;
using System.ComponentModel;
using System.Net;

namespace Win_CNPJ
{
    public partial class Form1 : Form
    {
        private String _nomeArquivo;
        private String _endPoint = "https://arquivos.receitafederal.gov.br/dados/cnpj/dados_abertos_cnpj";
        private String _nomePath = "C:\\Temp\\Download\\";
        private String _nomeZip;
        private String _nomeCsv;
        private String _URL;
        public Form1()
        {
            InitializeComponent();
        }

        private void Iniciar()
        {
            
            _URL = $"{txtUrl.Text}/{DateTime.Now.Year.ToString()}-{DateTime.Now.Month.ToString("D2")}";
            if (VerificarURL(_URL))
            {
                //_nomePath = $"C:\\Temp\\Receita\\";

            }
            else { MessageBox.Show($"NÃO EXISTE {_URL}"); }
        }
        private bool VerificarURL(String url)
        {
            WebRequest request = WebRequest.Create(url);

            try
            {
                //Envia a requisição e recebe uma resposta ,  não recebendo é lançada uma exceção e o código segue pro catch
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                //Testa se o status code da resposta foi 200 ,  que é retornado quando a url está online .

                if (response.StatusCode == HttpStatusCode.OK)
                {
                    // Execute seu código...
                    return true;
                }
                else
                {
                    //status code diferente de OK, manda pro catch
                    return false;
                }
            }
            catch
            {
                // Feche seu app aqui
                return false;

            }
        }
        private void startDownload(String url, String arquivo)
        {
            Thread thread = new Thread(() =>
            {
                WebClient client = new WebClient();
                client.DownloadProgressChanged += new DownloadProgressChangedEventHandler(client_DownloadProgressChanged);
                client.DownloadFileCompleted += new AsyncCompletedEventHandler((sender, e) => client_DownloadFileCompleted(arquivo, sender, e));
                String nomeArquivo = $"{Path.GetFileName(url)}/{arquivo}";
                client.DownloadFileAsync(new Uri($"{url}/{arquivo}.zip"), $"{_nomePath}{arquivo}.zip");
            });
            thread.Start();
        }
        void client_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            this.BeginInvoke((MethodInvoker)delegate
            {
                double bytesIn = double.Parse(e.BytesReceived.ToString());
                double totalBytes = double.Parse(e.TotalBytesToReceive.ToString());
                double percentage = bytesIn / totalBytes * 100;
                label.Text = "Baixado: " + e.BytesReceived + " of " + e.TotalBytesToReceive;
                progressBar1.Value = int.Parse(Math.Truncate(percentage).ToString());
            });
        }
        void client_DownloadFileCompleted(String arquivo, object sender, AsyncCompletedEventArgs e)
        {
            this.BeginInvoke((MethodInvoker)delegate
            {
                label.Text = "Download Completo";
                MessageBox.Show(arquivo);
                progressBar1.Value = 0;
            });
        }
        void client_DescompactarFileCompleted<EventArgs>(String arquivo, object sender, System.EventArgs e)
        {
            this.BeginInvoke((MethodInvoker)delegate
            {
                label.Text = "Download Completo";
                MessageBox.Show(arquivo);
                progressBar1.Value = 0;
            });
        }
        void Descompactar(String arquivo)
        {
            SevenZipBase.SetLibraryPath("C:\\Program Files\\7-Zip\\7z.dll");
            using (var zip = new SevenZipExtractor($"{_nomePath}{arquivo}.zip"))
            {
                zip.ExtractionFinished += new EventHandler<EventArgs>((sender, e) => client_DescompactarFileCompleted<EventArgs>(arquivo, sender, e));
                zip.ExtractArchive($"{_nomePath}");
                //client.DownloadFileCompleted += new AsyncCompletedEventHandler(client_DownloadFileCompleted);
                var arquivos = zip.ArchiveFileNames;
                FileInfo file = new FileInfo($"{_nomePath}{arquivos[0]}");
                if (file.Exists)
                {
                    FileInfo csv = new FileInfo($"{_nomePath}{arquivo}.csv");
                    if(csv.Exists)
                    {
                        csv.Delete();
                    }
                    File.Move($"{_nomePath}{arquivos[0]}", $"{_nomePath}{arquivo}.csv");
                }
            }
        }
        private void button1_Click(object sender, EventArgs e)
        {
            startDownload(_URL, "Empresas1");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Descompactar("Empresas1");
        }

        private void btnIniciar_Click(object sender, EventArgs e)
        {
            Iniciar();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Iniciar();
        }
    }
}
