unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, Menus, ComCtrls;

type

  // thread de traitement de l'image
  TTraitement=class(tthread)
  private
   ThFinal:tbitmap;                // bitmap temporaire avec le résultat
   ThOriginal:tbitmap;             // bitmap temporaire avec la source
   progression:integer;            // progression du traitement (en %)
   TabConLum:array[0..255] of byte;// table précalculée du contraste/luminosité
   procedure AfficheResultat;      // synchronize le résultat local avec le bitmap de Form1
   procedure AfficheProgression;   // synchronize la progression local avec le TProgressBar de Form1
  protected
    procedure Execute; override;   // boucle principale de traitement
  public
    Angle:integer;                 // paramètres de traitements
    variation:integer;
    taille:integer;
    Contraste:integer;
    Luminosite:integer;
    longueur:integer;
    quantite:integer;
    Restart:boolean;               // = true pour forcé le redémarrage du traitement au début
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;


  TForm1 = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    Ouvrir1: TMenuItem;
    Quitter1: TMenuItem;
    N1: TMenuItem;
    ScrollBox1: TScrollBox;
    PaintBox1: TPaintBox;
    Label1: TLabel;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    Label2: TLabel;
    ScrollBar3: TScrollBar;
    Label3: TLabel;
    ScrollBar4: TScrollBar;
    Label4: TLabel;
    ScrollBar5: TScrollBar;
    Label5: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    Enregistrer1: TMenuItem;
    Label6: TLabel;
    ScrollBar6: TScrollBar;
    ScrollBar7: TScrollBar;
    Label7: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Ouvrir1Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure Enregistrer1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Final:tbitmap;
    Original:tbitmap;
  end;

var
  Form1: TForm1;
  Traitement:TTraitement;


implementation

{$R *.dfm}


constructor TTraitement.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  // on crée le bitmap local
  thOriginal := TBitmap.Create;
  form1.Original.Canvas.Lock;                                                   // <<---- Ok
  // on y transfert l'image chargé dans Form1
  thOriginal.Assign(form1.Original);
  form1.Original.Canvas.UnLock;                                                 // <<---- Ok
  thOriginal.PixelFormat:=pf24bit;

  // on crée un deuxième bitmap pour le résultat
  thFinal := TBitmap.Create;
  thFinal.width:=thOriginal.Width;
  thFinal.Height:=thOriginal.Height;
  Restart:=true;
end;

destructor TTraitement.Destroy;
begin
 // destruction des bitmaps
  thFinal.Free;
  thOriginal.Free;
  inherited Destroy;
end;

// on met juste à jour la position de la progressbar
procedure TTraitement.AfficheProgression;
begin
 form1.ProgressBar1.Position:=progression;
end;

// on met à jour le bitmap FINAL et le paintbox de Form1
procedure TTraitement.AfficheResultat;
begin
 form1.Final.canvas.Draw(0,0,thfinal);
 form1.PaintBox1.Canvas.Draw(0,0,thfinal);
end;


//traitement principal
procedure TTraitement.Execute;
var
 i,j,l,tl,x,y,ii,jj,maxIt,progress:integer;
 a:single;
 r,v,b:integer;
 lum,cont,tai,ang,varia,lon,quant:integer;
 im1:pbytearray;
begin
  while not terminated do
   begin
    progression:=0;
    synchronize(AfficheProgression);
    // on attend un changement dans les paramètres
    while not restart and not terminated do ;
    restart:=false;
    // on "fige" les paramètres
    lum:=luminosite;
    cont:=contraste;
    tai:=taille;
    ang:=angle;
    varia:=variation;
    lon:=longueur;
    quant:=quantite;
    //précalcul du contraste luminosité
    for i:=0 to 255 do
     begin
      // luminosité
      l:=i+((255-i)*Lum) Div 255;
      // contraste
      tl :=(Abs(127-l)*Cont) Div 255;
      If (l > 127) Then l:=l+tl Else l:=l-tl;
      if l<0 then l:=0 else if l>255 then l:=255;
      TabConLum[i]:=l
     end;

    thfinal.Canvas.Lock;                                                         // <<---- Pourquoi ???
    thoriginal.Canvas.Lock;                                                      // <<---- Pourquoi ???
    // on efface le résultat
    thfinal.Canvas.FillRect(thfinal.canvas.ClipRect);
    // on calcul le nombre d'itération
    maxIt:=thoriginal.Height*thoriginal.width*quant div 100;
    for j:=1 to MaxIt do
     begin
      // si on demande d'arrêter, ben... heu... on arrête...
      if restart or terminated then break;
      // on choisi un pixel quelconque dans l'original
      x:=random(thoriginal.Width-7);
      y:=random(thoriginal.Height-7);
      r:=0;
      v:=0;
      b:=0;
      // on fait la moyenne des 49 pixels autours
      for jj:=y to y+6 do
       begin
        im1:=thoriginal.ScanLine[jj];
        for ii:=x to x+6 do
         begin
          // on applique en même temps le contraste/luminosité
          r:=r+TabConLum[im1[ii*3+2]];
          v:=v+TabConLum[im1[ii*3+1]];
          b:=b+TabConLum[im1[ii*3+0]];
         end;
       end;
       // on choisi un angle pour le trait de crayon
       a:=(angle+random(varia*2)-varia)*pi/180;
       // on trace le trait avec la couleur moyenne dans le résultat
       thfinal.Canvas.Pen.Width:=tai;
       thfinal.Canvas.Pen.Color:=rgb(r div 49,v div 49,b div 49);
       thfinal.canvas.MoveTo(x,y);
       thfinal.canvas.LineTo(round(x+lon*cos(a)),round(y+lon*sin(a)));
       // on met éventuellement à jour la progressbar de form1
       progress:=j*100 div MaxIt;
       if progression<>progress then
        begin
         progression:=progress;
         synchronize(AfficheProgression);
        end;
     end;
   thoriginal.Canvas.UnLock;                                                    // <<---- Pourquoi ???
   thfinal.Canvas.unLock;                                                       // <<---- Pourquoi ???
   // si aucune relance n'est demandée, on affiche le résultat dans le PaintBox
   if not restart and not terminated then synchronize(AfficheResultat);
  end;
end;

// TFORM1 ---- TFORM1 ---- TFORM1 ---- TFORM1 ---- TFORM1 ---- TFORM1 ----

procedure TForm1.FormCreate(Sender: TObject);
begin
 original:=tbitmap.Create;
 final:=tbitmap.Create;
 Traitement:=TTraitement.Create(false);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 traitement.Terminate;
 traitement.WaitFor;
 original.Free;
 final.Free;
end;


procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
 paintbox1.Canvas.Draw(0,0,final);
end;

procedure TForm1.Ouvrir1Click(Sender: TObject);
begin
 if not openpicturedialog1.Execute then exit;
 traitement.Terminate;
 traitement.WaitFor;
 original.LoadFromFile(openpicturedialog1.FileName);
 original.PixelFormat:=pf24bit;
 paintbox1.Width:=original.Width;
 paintbox1.Height:=original.Height;
 final.Assign(original);
 Traitement:=TTraitement.Create(false);
 ScrollBar1Change(nil);
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
 Traitement.Contraste:=scrollbar1.Position;
 Traitement.Luminosite:=scrollbar2.Position;
 Traitement.taille:=scrollbar3.Position;
 Traitement.Angle:=scrollbar4.Position;
 Traitement.Variation:=scrollbar5.Position;
 Traitement.Longueur:=scrollbar6.Position;
 Traitement.quantite:=scrollbar7.Position;
 label1.caption:=format('Contrast: %d%%',[scrollbar1.Position*100 div 255]);
 label2.caption:=format('Luminosité: %d%%',[scrollbar2.Position*100 div 255]);
 label3.caption:=format('Taille du crayon: %d',[scrollbar3.Position]);
 label4.caption:=format('Angle Principal: %d°',[scrollbar4.Position]);
 label5.caption:=format('Variation: ±%d°',[scrollbar5.Position]);
 label6.caption:=format('Longueur du trait: %d',[scrollbar6.Position]);
 label7.caption:=format('Quantité de Trait: %d%%',[scrollbar7.Position]);
 Traitement.Restart:=true;
end;

procedure TForm1.Enregistrer1Click(Sender: TObject);
begin
 if not savepicturedialog1.Execute then exit;
 final.SaveToFile(savepicturedialog1.FileName);
end;

end.
