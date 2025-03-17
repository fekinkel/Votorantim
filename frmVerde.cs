using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Documents;
using System.Windows.Controls;
using System.IO;
using System.Windows.Forms;

namespace WinFormMDI.Forms
{
    public partial class frmVerde : Form
    {
        private string _rtf;
        public frmVerde()
        {
            InitializeComponent();
            rtfEditor1.Enabled = true;
        }
        public void CarregarRTF(string rtf)
        {
            Dictionary<string, string> dic = new Dictionary<string, string>();
            dic.Add("Inscricao", "123456");
            dic.Add("Processo", "Ab12365");
            _rtf = rtf;
            rtfEditor1.Text = _rtf;
            rtfEditor1.MacroSubstituicao(dic);
            rtfEditor1.ReadOnly = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            var s = ConvertRtfToXaml(_rtf);
        }
        private static string ConvertRtfToXaml(string rtfText)
        {
            var richTextBox = new System.Windows.Controls.RichTextBox();
            if (string.IsNullOrEmpty(rtfText)) return "";
            var textRange = new TextRange(richTextBox.Document.ContentStart, richTextBox.Document.ContentEnd);
            using (var rtfMemoryStream = new MemoryStream())
            {
                using (var rtfStreamWriter = new StreamWriter(rtfMemoryStream))
                {
                    rtfStreamWriter.Write(rtfText);
                    rtfStreamWriter.Flush();
                    rtfMemoryStream.Seek(0, SeekOrigin.Begin);
                    textRange.Load(rtfMemoryStream, System.Windows.Forms.DataFormats.Rtf);
                }
            }
            using (var rtfMemoryStream = new MemoryStream())
            {
                textRange = new TextRange(richTextBox.Document.ContentStart, richTextBox.Document.ContentEnd);
                textRange.Save(rtfMemoryStream, DataFormats.Rtf);
                rtfMemoryStream.Seek(0, SeekOrigin.Begin);
                using (var rtfStreamReader = new StreamReader(rtfMemoryStream))
                {
                    return rtfStreamReader.ReadToEnd();
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            SaveFileDialog dialog = new SaveFileDialog();
            dialog.InitialDirectory = @"C:\\";
            dialog.Filter = "Ritch Text Format (rtf) |*.rtf";
            if (dialog.ShowDialog() == DialogResult.OK)
            {
                File.WriteAllText(dialog.FileName, rtfEditor1.Text);
            }

        }
    }
}
