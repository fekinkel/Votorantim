using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Tesseract;

namespace WinFormMDI.Forms
{
    public partial class frmImagem : Form
    {
        private bool arrastando;
        private Point offset;

        public frmImagem()
        {
            InitializeComponent();
        }

        private void btnRedimensionar_Click(object sender, EventArgs e)
        {
            Tuple<Bitmap, int, Bitmap> newImage;
            MemoryStream ms = new MemoryStream();
            if (radioButton1.Checked)
            {
                imgVertical.SizeMode = PictureBoxSizeMode.AutoSize;                
                imgVertical.Image.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
                var image = Image.FromStream(ms);
                newImage = ResizeImage(image, 720, 1050);
                imgResult.Image = newImage.Item3;
                imgResult.SizeMode = PictureBoxSizeMode.AutoSize;
            }
            else 
            {
                imgHorizontal.SizeMode = PictureBoxSizeMode.AutoSize;
                imgHorizontal.Image.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
                var image = Image.FromStream(ms);
                newImage = ResizeImage(image, 720, 1050);
                imgResult.Image = newImage.Item3;
                imgResult.SizeMode = PictureBoxSizeMode.AutoSize;
            }
            MemoryStream stream = new MemoryStream();

            //newImage.Item1.Save(stream, System.Drawing.Imaging.ImageFormat.Jpeg);
            newImage.Item3.Save(stream, System.Drawing.Imaging.ImageFormat.Jpeg);

            //stream = ms;

            newImage.Item1.Save($"D:\\Temp\\Teste_Forma_{newImage.Item2.ToString()}.jpg", System.Drawing.Imaging.ImageFormat.Png);
 
            newImage.Item3.Save($"D:\\Temp\\Teste_1_Forma_{newImage.Item2.ToString()}.jpg", System.Drawing.Imaging.ImageFormat.Png);

            byte[] byteArray = stream.GetBuffer();

            using (var engine = new TesseractEngine($@"D:\\0_Projeto_Web\\WebTorneioMJ\\WebTorneioMJ\\WebTorneioMJ\\wwwroot\\lib\\ocr", "por", EngineMode.Default))
            //using (var engine = new TesseractEngine($@"D:\\0_Projeto_Web\\WebTorneioMJ\\WebTorneioMJ\\WebTorneioMJ\\wwwroot\\lib\\ocr", "deu_latf", EngineMode.Default))
            //using (var engine = new TesseractEngine($@"D:\\0_Projeto_Web\\WebTorneioMJ\\WebTorneioMJ\\WebTorneioMJ\\wwwroot\\lib\\ocr", "eng", EngineMode.Default))
            {
                using (var img = Pix.LoadFromMemory(byteArray))
                {
                    using (var page = engine.Process(img))
                    {
                        var texto = page.GetText();
                        var t = texto.Split('\n');
                        string dupla_venceu = "";
                        string dupla_perdeu = "";
                        int d_venceu = -1;
                        int d_perdeu = -1;
                    }
                }
            }
        }
        Tuple<Bitmap, int, Bitmap> ResizeImage(System.Drawing.Image image, int width, int height)
        {
            //1.4584
            int formaNormal;
            int iniAltura;
            int iniLargura;
            int fimAltura;
            int fimLargura;
            List<Bitmap> img = new List<Bitmap>();
            List<formatoBitmap> fmtBit = new List<formatoBitmap>();

            if (image.Width > image.Height)
            {
                formaNormal = 0;
                iniAltura = 0;
                iniLargura = 750;
                fimAltura = 590;
                fimLargura = ((int)(image.Width)) - 100;
            }
            else
            {
                formaNormal = 1;
                iniAltura = 460;
                iniLargura = 0;
                fimAltura = ((int)(image.Width * 1.46));
                fimLargura = image.Width;
                fmtBit.Clear();
                fmtBit.Add(new formatoBitmap(80, 740, 340, 770) );
            }
            var destRect = new Rectangle(0, 0, fimLargura - iniLargura, fimAltura - iniAltura);
            var destImage = new Bitmap(fimLargura - iniLargura, fimAltura - iniAltura);
            destImage.SetResolution(image.HorizontalResolution, image.VerticalResolution);

            using (var graphics = Graphics.FromImage(destImage))
            {
                graphics.CompositingMode = CompositingMode.SourceCopy;
                graphics.CompositingQuality = CompositingQuality.HighQuality;
                graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                graphics.SmoothingMode = SmoothingMode.HighQuality;
                graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;

                using (var wrapMode = new ImageAttributes())
                {
                    wrapMode.SetWrapMode(WrapMode.TileFlipXY);

                    graphics.DrawImage(image, destRect, iniLargura, iniAltura, fimLargura-iniLargura, fimAltura-iniAltura, GraphicsUnit.Pixel, wrapMode);
                }
            }

            foreach(var item in fmtBit)
            {
                using (var graphics = Graphics.FromImage(item.imagem))
                {
                    graphics.CompositingMode = CompositingMode.SourceCopy;
                    graphics.CompositingQuality = CompositingQuality.HighQuality;
                    graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    graphics.SmoothingMode = SmoothingMode.HighQuality;
                    graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;

                    using (var wrapMode = new ImageAttributes())
                    {
                        wrapMode.SetWrapMode(WrapMode.TileFlipXY);

                        graphics.DrawImage(image, item.retangulo, item.pontoX, item.pontoY, item.pontoWidth, item.pontoHeight, GraphicsUnit.Pixel, wrapMode);
                    }
                }

            }
            var cor = destImage.GetPixel(200, 200);
            int ven = -1;
            //4, 157, 225 Azul Venceu
            if ((cor.R >= 0 & cor.R <= 14) & (cor.G >= 147 & cor.G <= 167) & (cor.B >= 215 & cor.B <= 235))
            { ven = 1; }
            //86, 20, 82 Roxo Perdeu
            else if ((cor.R >= 83 & cor.R <= 89) & (cor.G >= 17 & cor.G <= 23) & (cor.B >= 79 & cor.B <= 85))
            { ven = 0; }

            var retorno = new Tuple<Bitmap, int, Bitmap>(destImage, formaNormal, fmtBit[0].imagem);

            return retorno;
        }
        private class formatoBitmap
        {
            public Rectangle retangulo { get; }
            public Bitmap imagem {  get; }
            public int pontoX { get; }
            public int pontoY { get; }
            public int pontoWidth { get; }
            public int pontoHeight { get; }
            public formatoBitmap(int X, int Y, int Width, int Height)
            {
                pontoX  =   X; pontoY = Y; pontoWidth = Width - X; pontoHeight = Height - Y;
                retangulo = new Rectangle(0, 0, Width - X, Height - Y);
                imagem = new Bitmap(Width - X, Height - Y);
            }
        }

        private void frmImagem_Load(object sender, EventArgs e)
        {
            //pictureBox1.Parent = imgHorizontal;
        }

        private void imgVertical_DoubleClick(object sender, EventArgs e)
        {
            MessageBox.Show($"{(sender as PictureBox).Width.ToString()} x {(sender as PictureBox).Height.ToString()} ");
        }

        private void pictureBox1_DragDrop(object sender, DragEventArgs e)
        {
            int x = this.PointToClient(new Point(e.X, e.Y)).X;

            int y = this.PointToClient(new Point(e.X, e.Y)).Y;

            if (x >= pictureBox1.Location.X && x <= pictureBox1.Location.X + pictureBox1.Width && y >= pictureBox1.Location.Y && y <= pictureBox1.Location.Y + pictureBox1.Height)

            {

                string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);

                pictureBox1.Image = Image.FromFile(files[0]);

            }
        }

        private void pictureBox1_DragEnter(object sender, DragEventArgs e)
        {
            e.Effect = DragDropEffects.Move;
        }

        private void pictureBox1_MouseDown(object sender, MouseEventArgs e)
        {
            arrastando = true;
            offset = e.Location;
        }

        private void pictureBox1_MouseMove(object sender, MouseEventArgs e)
        {
            int dx = imgHorizontal.Size.Width - (sender as PictureBox).Width;
            int dy = imgHorizontal.Size.Height - (sender as PictureBox).Height;
            int lx = 0;
            int ly = 0;
            if (arrastando)
            {
                PictureBox pic = sender as PictureBox;
                int x1 = e.X + pic.Left - offset.X;
                int y1 = e.Y + pic.Top - offset.Y;
                if (x1 < dx && x1 > lx)
                {
                    pic.Left = x1; 
                }
                if (y1 < dy && y1 > ly)
                {
                    pic.Top = y1;
                }
            }
        }

        private void pictureBox1_MouseUp(object sender, MouseEventArgs e)
        {
            arrastando = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (pictureBox1.Parent.Name == "imgHorizontal")
            {
                pictureBox1.Parent = imgVertical;
            }
            else
            {
                pictureBox1.Parent = imgHorizontal;
                pictureBox1.BringToFront();
                pictureBox1.Location = new Point(0, 0);
                pictureBox1.BackColor = Color.Transparent;
                //pictureBox1.Location.Y = 0;
            }
        }
    }
}
