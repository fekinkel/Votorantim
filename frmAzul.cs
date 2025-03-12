using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using WinFormMDI.Forms;

namespace WinFormMDI
{
    public partial class frmAzul : Form
    {
        private frmVermelho frm;
        public frmAzul()
        {
            InitializeComponent();
        }

        private void btnVermelho_Click(object sender, EventArgs e)
        {
            if (frm != null)
            {
                frm.Close();
                frm.Dispose();
                frm = null;
            }
            if (frm == null)
            {
                frm = new frmVermelho();
            }
            frm.MdiParent = this.MdiParent;

            frm.Show();
        }

        private void frmAzul_LocationChanged(object sender, EventArgs e)
        {
            if (frm != null)
            {
                frm.Left = this.Location.X + this.Width;
                frm.Top = this.Location.Y;
            }
        }

        private void btnIncluir_Click(object sender, EventArgs e)
        {
            //OpenFileDialog dialog = new OpenFileDialog();
            //dialog.InitialDirectory = @"D:\0_0";
            //dialog.Filter = "Ritch Text Format (rtf) |*.rtf";
            //if (dialog.ShowDialog() == DialogResult.OK)
            {
                richTextBox1.LoadFile($"D:\\0_0\\Exemplo.rtf");
            }
        }

        private void textBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Char.IsDigit(e.KeyChar) && e.KeyChar != 08)
            {
                e.Handled = true;
            }
            else
            {
                if (Char.IsControl(e.KeyChar))
                {
                    int val;
                    if (Int32.TryParse(Clipboard.GetText(), out val))
                    {
                        e.Handled = true;
                        MessageBox.Show($"Ctrl + V e valor é  {Clipboard.GetText()}");
                        textBox1.Text = $"{textBox1.Text}{Clipboard.GetText()}";
                    }
                    else
                    {
                        e.Handled = false;
                    }
                }
            }
        }

        private void textBox1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Control && e.KeyCode == Keys.V)
            {
                int val;
                if (Int32.TryParse(Clipboard.GetText(), out val))
                {
                    e.Handled = true;
                    //MessageBox.Show($"Ctrl + V e valor é  {Clipboard.GetText()}");
                    textBox1.Text = $"{textBox1.Text}{Clipboard.GetText()}";
                }
                else
                {
                    e.Handled = false;
                }
            }
        }

        private void textBox1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                int val;
                if (Int32.TryParse(Clipboard.GetText(), out val))
                {

                }
                else
                {
                    Clipboard.Clear();
                }
            }
        }

        private void toolTip1_Popup(object sender, PopupEventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            string str = richTextBox2.Text;

            Stream stringStream = StrToStream(str);
            richTextBox1.LoadFile(stringStream, System.Windows.Forms.RichTextBoxStreamType.PlainText);
        }
        private Stream StrToStream(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);

            /*Stream stringStream = new MemoryStream();
            stringStream.Read(bytes, 0, str.Length);
            stringStream.WriteByte(13);
            stringStream.Position = 0;
            */

            var stream = new MemoryStream();
            StreamWriter writer = new StreamWriter(stream);
            writer.Write(str);
            writer.Flush();
            stream.Position = 0;
            //Stream reader = Stream;// StreamReader(stream); //aqui já está consumindo o stream
            //Stream stringStream = reader.ReadToEnd();
            return null;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            richTextBox2.SaveFile($"D:\\0_0\\Exemplo_2.rtf");
            richTextBox1.SaveFile($"D:\\0_0\\Exemplo_1.rtf");
        }

        private void salvarArquivo()
        {
            string s = richTextBox1.Text;
            string[] str = richTextBox1.Text.Split(new string[] { "\r\n", "\r", "\n" },    StringSplitOptions.None);
            string docPath = "D:\\0_0\\";

            // Write the string array to a new file named "WriteLines.txt".
            using (StreamWriter outputFile = new StreamWriter(Path.Combine(docPath, "Exemplo_s.rtf")))
            {
                foreach (string line in str)
                    outputFile.WriteLine(line);
            }
            richTextBox2.LoadFile($"D:\\0_0\\Exemplo_s.rtf");

            //File.Delete($"D:\\0_0\\Exemplo_s.rtf");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            salvarArquivo();
        }
    }
}

